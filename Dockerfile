FROM ubuntu:20.04
LABEL maintainer="Isak Hammer"

SHELL ["/bin/bash", "-c"]

ENV TZ=Europe/Oslo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV HOME_DIR /root

# ESSENTIAL
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -yq apt-utils dialog apt-transport-https wget libasound2
RUN apt-get install -yq build-essential software-properties-common
RUN apt-get update

# potential dependencies
RUN apt-get -y install curl snapd
RUN apt-get -y install dirmngr
RUN apt-get -y install apt-transport-https lsb-release
RUN apt-get -y install lsb-release
RUN apt-get -y install ca-certificates
RUN apt-get -y install gcc g++ make
RUN apt-get -y install openjdk-11-jdk
RUN apt-get -y install poppler-utils # pdftoppm and pdftocairo

RUN apt-get install -yq git cmake make
RUN apt-get install -yq bc libblas-dev liblapack-dev
RUN apt-get install -yq xclip feh

RUN apt-get install -yq xorg-dev mesa-utils \
    xvfb libgl1 freeglut3-dev libxrandr-dev \
    libxinerama-dev libxcursor-dev libxi-dev libxext-dev
RUN apt-get install -yq jabref

# VSCODE
#RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
#RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
#RUN apt-get -yq install code
#RUN code --install-extension  --user-data-dir="~/.vscode-root" \
#                                James-Yu.latex-workshop \
#                                streetsidesoftware.code-spell-checker


# Dependencie in ubuntu for vimtex -> zathura interface
RUN apt-get install -yq dbus-x11

# Deep bug somwhere when installing matplotlib on ubuntu20
# https://stackoverflow.com/questions/25674612/ubuntu-14-04-pip-cannot-upgrade-matplotllib
RUN apt-get install -yq libfreetype6-dev libxft-dev


# python3.8
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get -y update
RUN apt-get install -yq python3.8 python3.8-tk python3.8-dev
RUN apt-get install -yq python3-pip python3.8-venv
RUN /usr/bin/python3.8 -m pip install --upgrade pip
RUN pip3 install --upgrade pip

# Create workbox folder and environment variables
RUN mkdir -p $HOME_DIR/workbox
ENV WORKBOX_DIR $HOME_DIR/workbox
ENV CONFIG_DIR $WORKBOX_DIR/config
ENV DEP_DIR $WORKBOX_DIR/dependencies
WORKDIR $WORKBOX_DIR
RUN mkdir $HOME_DIR/.config

# INSTALL WORKBOX

# Copy all files from host to container
COPY . .

RUN mkdir -p ~/.config/neofetch
RUN ln -s $CONFIG_DIR/neofetch/config.conf ~/.config/neofetch/config.conf
RUN apt-get install -yq neofetch

# Installing the fonts
### arggh still not able to generate all fonts in julia in vim
RUN mkdir -p $HOME_DIR/.local/share/fonts/
RUN ln -s $DEP_DIR/JuliaMono-Regular.ttf $HOME_DIR/.local/share/fonts/
RUN apt-get install -yq fontconfig
RUN fc-cache -f -v

# Source common_scripts into .bashrc
RUN echo "source ${WORKBOX_DIR}/common_scripts.sh" >> /root/.bashrc

# installation of python packages
RUN pip3 install -r $DEP_DIR/requirements.txt

# Jupyter installations
# buggy
# RUN jupyter nbextension install --user --py widgetsnbextension
# RUN jupyter nbextension enable --user --py widgetsnbextension
# RUN jupyter nbextension install --user --py webgui_jupyter_widgets
# RUN jupyter nbextension enable --user --py webgui_jupyter_widgets

# Standard ngsolve installation
# Might want to consider pip3 install NGsolve
RUN apt-add-repository universe
RUN add-apt-repository ppa:ngsolve/ngsolve
RUN apt-get update
RUN apt-get install -yq ngsolve


# LATEX
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get upgrade -y
RUN apt-get install -y latexmk
RUN apt-get install -y texlive-full
RUN apt-get install -y biber
RUN apt-get install -y pandoc
RUN apt-get install -yq rxvt-unicode # display unicode in terminal


# Zathura
RUN apt-get -y install zathura
RUN mkdir -p ~/.config/zathura
RUN ln -s $CONFIG_DIR/zathurarc ~/.config/zathura/zathurarc
RUN apt-get install -yq xdotool # for vimtex-zathura interface


# Tmux
RUN apt-get install -yq tmux
RUN ln -s $CONFIG_DIR/tmux.conf ~/.tmux.conf

## Julia
## Install Juliaup
ENV JULIA_VERSION=1.8.5

RUN curl -fsSL https://install.julialang.org -o install_julia.sh \
    && sh install_julia.sh --yes

ENV PATH=/root/.juliaup/bin:$PATH
RUN source /root/.bashrc \
    && cat /root/.bashrc \
    && juliaup add $JULIA_VERSION  \
    && juliaup default $JULIA_VERSION

# RUN julia -e 'using Pkg; Pkg.add(["UpdateJulia"])'
# RUN julia -e 'using UpdateJulia; update_julia() '
RUN julia $DEP_DIR/requirements.jl
RUN mkdir -p ~/.julia/config
RUN ln -s $CONFIG_DIR/startup.jl ~/.julia/config/startup.jl

# Ranger
RUN ln -s $CONFIG_DIR/ranger ~/.config/ranger

# NEOVIM
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get -y update
RUN apt-get -y install neovim ripgrep
RUN apt-get -y install curl
RUN apt-get -y update

ARG NODE_VERSION=16
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y && \
    curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - && \
    apt-get install -y nodejs

RUN mkdir -p ~/.config/nvim/ && touch ~/.config/nvim/init.vim && echo "source ${CONFIG_DIR}/nvim/init.vim" >> ~/.config/nvim/init.vim
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qall

# Dont forget to uncomment vimrc as well
# RUN nvim +'CocInstall -sync coc-julia coc-jedi coc-json' +qall
# RUN nvim +CocUpdateSync +qall
# coc-julia installation
# RUN julia --project="/root/.config/coc/extensions/node_modules/coc-julia/server/JuliaLS" --startup-file=no --history-file=no -e "using Pkg; Pkg.instantiate()"
# RUN julia --project="/root/.config/coc/extensions/node_modules/coc-julia/server/compile_env" --startup-file=no --history-file=no -e "using Pkg; Pkg.instantiate()"
# RUN nvim +'CocCommand julia.CompileLanguageServerSysimg' +qall


# Utilities
RUN apt-get install -yq inkscape

# FEM libraries
RUN apt-get install -yq paraview gmsh


# For regular code
RUN mkdir -p $HOME_DIR/code
ENV WORK_DIR $HOME_DIR/code
WORKDIR $WORK_DIR

# Source after the end of installation
RUN source /root/.bashrc

