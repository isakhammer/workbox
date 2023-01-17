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

Then modify and apply the following script:

```
# Installation
PATH_TO_WORKBOX_REPO="$HOME/workbox"
git clone https://github.com/isakhammer/workbox.git ~/workbox # Even better if this is your fork
echo 'alias workbox="bash ${PATH_TO_WORKBOX_REPO}/run_workbox.sh"' >> $HOME/.bashrc && source ~/.bashrc 

# Quick start
cd $PATH_TO_WORKBOX_REPO/template # Changing directory to some example project, here we do the template.
workbox # Starting an instance of the workbox.
```
 
## Further Notes 
- The repo should be forked and personalized. Remark that the best way is to let github actions to the build procedure and then push the latest installation to your personal Docker Hub. 
- Do not hesitate to put up any issues you have any questions. :slightly_smiling_face:	


  
  
