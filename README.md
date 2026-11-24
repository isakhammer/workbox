
# Workbox
**Multifunctional docker workbox for scientific Linux workflow!**

Docker environment for vim workflow of latex development (inspired by this [blog](https://castel.dev/post/lecture-notes-1/)) and basic scientific programming (Python and Julia). A similar concept for VScode is the so-called [devcontainers](https://code.visualstudio.com/docs/devcontainers/containers). However, this workflow is focusing on developing using vim inside the container.

## Introduction
For quite some time have I been struggling with annoyance of random issues that pop up in terms of my vim and latex environment such as vim mapping collisions, multiprogram compatibility problems and more. Therefore, I created a docker environment to install everything I need from scratch, which makes is easy to reproduce any flaws in my workflow and fix it straight away.

Anyhow, I started to find this docker environment useful for daily workflow, hence the name workbox. The concept is basically to mount the docker container, with fully installed features, to your workspace repo. It is now possible to easily combine compiling any scientific latex projects, launch jupyter notebooks, run simulations and use custom vim bindings in one go.

## Main Features:
  - [Neovim](https://github.com/neovim/neovim) with [vimtex](https://github.com/lervag/vimtex), [UltiSnips](https://github.com/SirVer/ultisnips) with custom mathematical tex snippets and the autocomplete [coc.nvim](https://github.com/neoclide/coc.nvim) and more.
  - Latexmk and TeX Live packages for the bundled LaTeX template
  - [Zathura](https://github.com/pwmt/zathura) for pdf viewing and [ranger](https://github.com/ranger/ranger) for file managing.
  - Python3 and Julia installed with most packages for basic scientific programming.
  - Running Jupyter Notebooks with no problems

## How to run Workbox
You need to have docker installed, see [link](https://docs.docker.com/desktop/install/linux-install/).

Clone the repository, then keep the shared links in your existing host setup:

```
git clone https://github.com/isakhammer/workbox.git ~/work/workbox
```

Add this compact block to `~/.bashrc-personal` (adjust the checkout path if needed):

```bash
# Define Workbox symlinks (Ranger and Zathura).
if [[ -f "$HOME/work/workbox/symlink_host.sh" ]] &&
   bash "$HOME/work/workbox/symlink_host.sh" >/dev/null; then
    source "$HOME/.config/ranger/shell.sh"
fi
```

Reload your existing host setup:

```bash
source ~/.bashrc-personal
cd ~/work/workbox/template
wb
```

The symlink script creates `wb`/`workbox` and `wb-zathura` in
`~/.local/bin`, plus the shared Ranger, Kitty and Zathura configuration.
The shared Ranger shell file defines `r` and adds `~/.local/bin` to `PATH`.
Existing files are backed up under
`~/.local/state/workbox/backups/`. Running it again keeps links already in place.
Docker must be running and accessible to your user (`docker info`).

Use `./symlink_host.sh --dry-run` to inspect the links first, or `--home DIRECTORY`
to stage them in another directory.
Install dependencies separately through your package manager. Host previews use
Kitty, Ranger, Zathura with a PDF plugin, Poppler, Pillow and Pygments; Zathura
navigation also uses `gdbus` and `xdotool`.

For graphical PDF previews, use Kitty as your terminal and start Workbox normally.
Run `r` inside it and move between PDF files with `j` and `k` to see the first
page in Ranger's preview pane. Everything stays in the same terminal. The Kitty
terminal description is bundled and loaded automatically in new containers.
After configuration changes, restart Workbox to reload its shell settings.
When launched with `r`, quitting Ranger leaves the shell in the last directory
you visited in Ranger.
To share the configuration with host Ranger, back up `~/.config/ranger` and
symlink it to this repository's `config/ranger` directory. Both then use the
same key bindings, preview scripts, and shell integration.

With the shared Zathura configuration, `n` opens the next PDF in the current document's
folder and `p` opens the previous one, in the same window. Files are sorted
naturally by filename and navigation wraps at the ends. Printing is `Ctrl+p`.
After `n`, Zathura also runs `a` to fit the whole page in the window.
Type `se` (without a colon) to edit `zathurarc` in Neovim in a terminal window.
The former `s` (fit-to-width) action is available as `sw`.

## Updating Neovim and VimTeX
Neovim is pinned to v0.12.6 in `Dockerfile`, with SHA-256 checksums for both
supported architectures. VimTeX is pinned to v2.18 in `config/nvim/init.vim`.
Update these versions together, refresh the checksums from the official Neovim
release, and rebuild. The build checks that VimTeX loads successfully in Neovim.

```bash
cd ~/work/workbox
bash build_workbox.sh
```

Exit the current Workbox container and run `wb local` from your document folder
to use the rebuilt `workbox:latest` image. Plain `wb` uses
`isakhammer/workbox:latest`; to use the local build with that command too, run:

```bash
docker tag workbox:latest isakhammer/workbox:latest
```

Restart Neovim after changing plugin versions. Existing containers retain their
installed editor and plugins until you restart Workbox with the new image.

## Optional scientific packages

The standard image includes VimTeX, Zathura, Ranger, the TeX Live packages
needed by the bundled template, and Python. Use a project virtual environment
for additional Python packages.

Build the expanded image for Julia, JupyterLab, the previous Julia package
collection, Netgen/NGSolve, XFEM, CasADi, or full TeX Live:

```bash
docker build --build-arg WORKBOX_EXTRAS=1 -t workbox:latest .
```

Use `wb local` for the expanded image. To start its JupyterLab server, run
`juplab` inside the container, or tag it as `isakhammer/workbox:latest` and run
`wb jupyter`.

## Further Notes
- The repo should be forked and personalized.
- The most optimized workflow is to let Github Actions build the Dockerfile automatically and then push the latest image to your personal Docker Hub, which you then can pull whenever you want. You can check out how to do this in my workflow yaml file [here](https://github.com/isakhammer/workbox/blob/master/.github/workflows/docker-image.yml) which automatically is pushing the latest successful build to my personal [hub](https://hub.docker.com/r/isakhammer/workbox).
- Do not hesitate to put up any issues if you have any questions :slightly_smiling_face:








