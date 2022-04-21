# Workbox
**Multi Purpose Workbox for Scientific Linux Workflow!**

Docker environment for vim workflow of latex development inspired by this [blog](https://castel.dev/post/lecture-notes-1/) and basic scientific programming using Python and Julia.

For quite some time have I been struggling with annoyance of random issues that pop up in terms of my vim and latex environment during my master thesis. I realized that installing everything at the host operating system and fix things on the go was risky since I could not guarantee a stable system. Therefore, I now created a workbox inside a docker container with every installation I need, which makes is easy to install, write, compile and reproduce any errors.

The concept is simply that the workbox, which is a docker container with fully installed features, is mounted to your workspace repo. It is now possible to easily combine compiling any latex projects, jupyter notebooks, run simulations and use custom vim bindings in one go with exactly the same setup on any linux device. 

## Main Features:
  - Neovim with vimtex, UltiSnips with custom mathematical tex snippets and coc.nvim.  
  - Fully installed Latexmk compiler and all basic fonts packages via `texlive-full`
  - Zathura for pdf viewing and Ranger for file managing. 
  - Python3 and Julia installed with most packages for basic scientific programming.
  - Running Jupyter Notebooks

## How to run Workbox

Clone repo and put this into your `.bashrc`, remember to fill in the correct path to workbox repo.
```
alias workbox="bash {$PATH_TO_WORKBOX_REPO}/run_workbox.sh"
```
Now, go into in to any folder and run the bash alias `workspace`. The command will now create a docker container which the volume of folder is mounted to the container path `/root/code`. Similarly, the cloned workbox repo volume is by default mounted to the container path `/root/workbox`.

Now you are free to run most julia scripts, python scripts and write/compile latex documents.

## Example of Latex Compilation

We now want to compile the already mentioned [template](https://github.com/isakhammer/workbox/tree/master/template). Go into the repo and access the template folder. Now, use the alias by writing `workbox`. You will now create a workbox container and be directed to the template folder inside `/root/code`.

  1) To compile the latex documents, first run zathura inside `/root/code` using the command `zbg` (the alias is defined in the [commons scripts](https://github.com/isakhammer/workbox/blob/master/common_scripts.sh)) to open the `main.pdf`.

  2) Now access any `.tex` using vim, for instance `vim main.tex` and to start automatic compilation use the vimtex alias `\ll`(read more at the vimtex documentation [here](https://github.com/lervag/vimtex)). 

The latex document should now be compiled.


## Build Image Locally
Make sure you have a linux or mac docker environment installed according to [here](https://docs.docker.com/get-docker/).

To build the workbox, simply clone the repo and run,
```
bash build_workbox.sh
```
It will now build the docker image with  the image name `workbox`. To run it, use the alias mentioned above and add a `local` flag uch that: 
```
workbox local
```

## Further Notes
- If you want to really exploit this system, please study the setup of [config](https://github.com/isakhammer/workbox/tree/master/config), [common_scripts.sh](https://github.com/isakhammer/workbox/blob/master/common_scripts.sh) and the [Dockerfile](https://github.com/isakhammer/workbox/blob/master/Dockerfile) in detail. Most of the configurations are symbolic links to files in `~/.config` inside the container, with some exceptions such as nvim.
- At the moment is my [tex snippets](https://github.com/isakhammer/workbox/blob/master/config/nvim/UltiSnips/tex.snippets) taking advantage of my norwegian keyboard using letters `øæå` as aliases for common math snippets. Feel free to customize. 
- I am working towards on making this to a multi-purpose workbox with basic packages used in scientific programming.
- Feel free creating issues! I am happy to help.

  
  
