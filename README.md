# Workbox
**Multifunctional workbox for scientific Linux workflow!**

Docker environment for vim workflow of latex development (inspired by this [blog](https://castel.dev/post/lecture-notes-1/)) and basic scientific programming (Python and Julia). A similar concept for VScode is the so-called [devcontainers](https://code.visualstudio.com/docs/devcontainers/containers). However, this workflow is specifically for vim development.

## Introduction
For quite some time have I been struggling with annoyance of random issues that pop up in terms of my vim and latex environment such as vim mapping collisions, multiprogram compatibility problems and more. Therefore, I created a docker environment to install everything I need from scratch, which makes is easy to reproduce any flaws in my workflow and fix it straight away. 

Anyhow, I started to find this docker environment useful for daily workflow, hence the name workbox. The concept is basically to mount the docker container, with fully installed features, to your workspace repo. It is now possible to easily combine compiling any scientific latex projects, launch jupyter notebooks, run simulations and use custom vim bindings in one go. 

## Main Features:
  - Neovim with vimtex, UltiSnips with custom mathematical tex snippets and coc.nvim.  
  - Fully installed Latexmk compiler and all basic fonts packages via `texlive-full`
  - Zathura for pdf viewing and Ranger for file managing. 
  - Python3 and Julia installed with most packages for basic scientific programming.
  - Running Jupyter Notebooks

## How to run Workbox
You need to have docker installed, see [link](https://docs.docker.com/desktop/install/linux-install/).

```
# Installation
PATH_TO_WORKBOX_REPO="$HOME/workbox"
git clone https://github.com/isakhammer/workbox.git ~/workbox # Even better if this is your fork
echo 'alias workbox="bash ${PATH_TO_WORKBOX_REPO}/run_workbox.sh"' >> $HOME/.bashrc && source ~/.bashrc 

# Quick start
cd $PATH_TO_WORKBOX_REPO/template # Changing directory to some example project, here we do the template.
workbox # Starting an instance of the workbox.
zathura main.pdf 
```
 
## Further Notes 
- If you want to really exploit this system, please fork the repository and study the setup of [config](https://github.com/isakhammer/workbox/tree/master/config), [common_scripts.sh](https://github.com/isakhammer/workbox/blob/master/common_scripts.sh) and the [Dockerfile](https://github.com/isakhammer/workbox/blob/master/Dockerfile) in detail. Most of the configurations are symbolic links to files in `~/.config` inside the container, with some exceptions such as nvim.
- At the moment is my [tex snippets](https://github.com/isakhammer/workbox/blob/master/config/nvim/UltiSnips/tex.snippets) taking advantage of my norwegian keyboard using letters `øæå` as aliases for common math snippets. 


  
  
