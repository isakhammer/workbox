#!/usr/bin/env python3
"""Open the next/previous PDF in the invoking Zathura window via D-Bus."""

import ast
import os
from pathlib import Path
import re
import subprocess
import sys


def run(*args):
    return subprocess.check_output(
        args, text=True, encoding='utf-8', stderr=subprocess.PIPE, timeout=10,
        env=dict(os.environ, LC_ALL='C.UTF-8'),
    ).strip()


def is_zathura(pid):
    try:
        return (Path('/proc') / str(pid) / 'comm').read_text().strip() == 'zathura'
    except OSError:
        return False


def invoking_pid():
    # This works when the helper is a direct or indirect child of Zathura.
    pid = os.getppid()
    while pid > 1:
        if is_zathura(pid):
            return pid
        try:
            status = (Path('/proc') / str(pid) / 'status').read_text()
            pid = int(re.search(r'^PPid:\s+(\d+)', status, re.MULTILINE).group(1))
        except (OSError, AttributeError):
            break
    # GLib can detach external commands. The shortcut still has keyboard focus
    # in its own window, whose X11 PID is in the same container namespace.
    for query in ('getwindowfocus', 'getactivewindow'):
        try:
            pid = int(run('xdotool', query, 'getwindowpid'))
            if is_zathura(pid):
                return pid
        except (OSError, ValueError, subprocess.SubprocessError):
            continue
    raise RuntimeError('Could not identify the Zathura window invoking the shortcut')


def call(bus, method, *args):
    return run('gdbus', 'call', '--session', '--dest', bus,
               '--object-path', '/org/pwmt/zathura', '--method', method, *args)


def natural_key(path):
    return [int(part) if part.isdigit() else part.casefold()
            for part in re.split(r'(\d+)', path.name)]


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in ('next', 'previous'):
        raise ValueError('Usage: zathura-pdf-neighbor.py next|previous')
    pid = invoking_pid()
    bus = 'org.pwmt.zathura.PID-{}'.format(pid)
    response = call(bus, 'org.freedesktop.DBus.Properties.Get',
                    'org.pwmt.zathura', 'filename')
    if not (response.startswith('(<') and response.endswith('>,)')):
        raise RuntimeError('Unexpected Zathura filename response: ' + response)
    filename = ast.literal_eval(response[2:-3])
    if not isinstance(filename, str) or not filename:
        return
    current = Path(filename).absolute()
    files = sorted((p for p in current.parent.iterdir()
                    if p.is_file() and p.suffix.casefold() == '.pdf'),
                   key=natural_key)
    if len(files) < 2:
        return
    delta = 1 if sys.argv[1] == 'next' else -1
    try:
        index = files.index(current)
        target = files[(index + delta) % len(files)]
    except ValueError:
        target = files[0 if delta > 0 else -1]
    result = call(bus, 'org.pwmt.zathura.OpenDocument', str(target), '', '0')
    if result != '(true,)':
        raise RuntimeError('Zathura could not open ' + str(target))
    if delta > 0:
        # Run the actual a binding after loading, without changing adjust-open.
        windows = run('xdotool', 'search', '--all', '--onlyvisible',
                      '--pid', str(pid), '--class', 'Zathura').splitlines()
        if not windows:
            raise RuntimeError('Could not find the Zathura window to fit the page')
        run('xdotool', 'key', '--window', windows[0], 'a')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, RuntimeError, subprocess.SubprocessError) as error:
        print('PDF navigation: {}'.format(error), file=sys.stderr)
        sys.exit(1)
