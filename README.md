# Workbox
Complete ubuntu and vim environment for latex development in a docker container based on this fantastic [blog](https://castel.dev/post/lecture-notes-1/) based on [Gilles Castels work](https://github.com/gillescastel). 

For quite some time have I been struggling with annoyance of random issues that pop up in terms of my vim and latex environment during my master thesis. I realized that installing everything at the host operating system and fix things on the go was risky since I could not guarantee a stable system. Therefore, I now created a workbox inside a docker container with every installation I need which makes is easy to install, write, compile and reproduce any errors.

The concept is simply that the workbox, which is a docker container with fully installed features, is mounted to your latex workspace repo similar to the given template [here](https://github.com/isakhammer/workbox/tree/master/template) and this workbox repo. It is now possible to easily compile the latex document and have a custom vim setup for everything. In my opionion 



## How to run Workbox

Put this into your `.bashrc`, remember to fill in the correct path to workbox repo.
```
alias workbox="bash {$PATH_TO_WORKBOX_REPO}/run_workbox.sh"
```
Now, go into in to any latex workspace folder and run the bash alias `workspace`. The command will now create a docker container which the volume of latex workspace folder is mounted to the container path `/root/code` and similarly the cloned workbox repo volume is mounted to the container path `/root/workbox`, which means if you edit the latex workspace or change the workbox repo inside the container the changes will be synched with the original folder.

## Example of Latex Compilation

We now want to compile the already mentioned [template](https://github.com/isakhammer/workbox/tree/master/template). Go into the repo and access the template folder. Now, use the alias by writing `workbox`. You will now create a workbox container and be directed to the template folder inside `/root/code`.

  1) To compile the latex documents, first run zathura inside `/root/code` using the command `zathura_bg` (the command is defined in the alias [here] (https://github.com/isakhammer/workbox/edit/master/common_scripts.sh)) to open the `main.pdf` if it does exist.

  2) Now access any `.tex` using vim, for instance `vim main.tex` and to start automatic compilation use the vimtex alias `\ll`(read more at the vimtex documentation [here](https://github.com/lervag/vimtex)). 

The latex document should now be compiled.


## Build Image Locally
Make sure you have a linux or mac docker environment installed according to [here](https://docs.docker.com/get-docker/).

To build the workbox, simply clone the repo and run,
```
bash build_workbox.sh
```
It will now build the docker image with the image name `workbox` in around 15-20 mins. To run it, use the command `workbox local`.


## Further Notes
- If you want to really exploit this system, please study the setup of [vim_setup](https://github.com/isakhammer/workbox/tree/master/vim_setup),[common_scripts.sh](https://github.com/isakhammer/workbox/blob/master/common_scripts.sh) and the installation procedure in detail. At the moment is it design for my purpose and my needs. However, feel free to fork the project and make your own. 
- At the moment is my [tex snippets](https://github.com/isakhammer/workbox/blob/master/vim_setup/UltiSnips/tex.snippets) taking advantage of my norwegian keyboard usingletters`øæå` as aliases for very common snippets. 
- I am working towards on making this to a multi-purpose workbox with basic packages used in scientific programming.
- Feel free creating issues! I am happy to help.
- 
## Main Features:
  - Neovim with vimtex environment
  - UltiSnips 
  - Coc
  - Latexmk
  - zathura
  
  
