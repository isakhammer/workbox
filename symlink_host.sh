#!/usr/bin/env bash
set -euo pipefail

workbox_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
host_home=$HOME
dry_run=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --home) host_home=${2:?--home requires a directory}; shift 2 ;;
        --dry-run) dry_run=true; shift ;;
        -h|--help)
            echo 'Usage: symlink_host.sh [--home DIRECTORY] [--dry-run]'
            echo 'Link host configuration and commands; back up existing files.'
            exit 0 ;;
        *) echo "Unknown argument: $1" >&2; exit 2 ;;
    esac
done
host_home=$(realpath -m -- "$host_home")
backup_root="$host_home/.local/state/workbox/backups/$(date +%Y%m%d-%H%M%S)-$$"

function prepare_backup() {
    mkdir -p -m 700 -- "$backup_root"
    chmod 700 -- "$backup_root"
}

function link_file() {
    local source=$1 destination=$2 backup
    [[ -e "$source" ]] || { echo "Missing source: $source" >&2; exit 1; }
    if [[ -L "$destination" && "$(readlink -f -- "$destination")" == "$source" ]]; then
        printf 'Already linked: %s\n' "$destination"
        return
    fi
    if $dry_run; then
        printf 'Would link: %s -> %s (backing up any existing entry)\n' "$destination" "$source"
        return
    fi
    if [[ -e "$destination" || -L "$destination" ]]; then
        prepare_backup
        backup="$backup_root/${destination#"$host_home/"}"
        mkdir -p -m 700 -- "$(dirname -- "$backup")"
        mv -- "$destination" "$backup"
    fi
    mkdir -p -- "$(dirname -- "$destination")"
    ln -s -- "$source" "$destination"
    printf 'Linked: %s -> %s\n' "$destination" "$source"
}

link_file "$workbox_root/bin/wb" "$host_home/.local/bin/wb"
link_file "$workbox_root/bin/wb" "$host_home/.local/bin/workbox"
link_file "$workbox_root/bin/wb-zathura" "$host_home/.local/bin/wb-zathura"
link_file "$workbox_root/config/ranger" "$host_home/.config/ranger"
link_file "$workbox_root/config/kitty/kitty.conf" "$host_home/.config/kitty/kitty.conf"
link_file "$workbox_root/config/zathurarc" "$host_home/.config/zathura/zathurarc"

if [[ -d "$backup_root" ]]; then
    printf 'Backups: %s\n' "$backup_root"
fi
printf '\nBash setup, if not already sourced:\n'
printf 'source "$HOME/.config/ranger/shell.sh"\n'
