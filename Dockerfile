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
RUN apt-get install -yq apt-utils dialog
RUN apt-get install -yq build-essential software-properties-common
RUN apt-get update

# potential dependencies
RUN apt-get -y install curl
RUN apt-get -y install dirmngr
RUN apt-get -y install apt-transport-https lsb-release
RUN apt-get -y install lsb-release
RUN apt-get -y install ca-certificates
RUN apt-get -y install gcc g++ make
RUN apt-get install -yq git cmake make
RUN apt-get install -yq bc libblas-dev liblapack-dev
RUN apt-get install -yq xclip

# Deep bug somwhere when installing matplotlib on ubuntu20
# https://stackoverflow.com/questions/25674612/ubuntu-14-04-pip-cannot-upgrade-matplotllib
RUN apt-get install -yq libfreetype6-dev libxft-dev


# python3.8
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get -y update
RUN apt-get install -y python3.8 python3.8-tk python3.8-dev
RUN apt-get -y install python3-pip
RUN /usr/bin/python3.8 -m pip install --upgrade pip
RUN pip3 install --upgrade pip

# Create workbox folder
RUN mkdir -p $HOME_DIR/workbox
ENV WORKBOX_DIR $HOME_DIR/workbox
WORKDIR $WORKBOX_DIR

# INSTALL WORKBOX
COPY . .
RUN pip3 install -r $WORKBOX_DIR/requirements.txt
RUN echo "source ${WORKBOX_DIR}/common_scripts.sh" >> /root/.bashrc

# Jupyter
RUN jupyter nbextension install --user --py widgetsnbextension
RUN jupyter nbextension enable --user --py widgetsnbextension
RUN jupyter nbextension install --user --py webgui_jupyter_widgets
RUN jupyter nbextension enable --user --py webgui_jupyter_widgets

# Standard ngsolve
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


# Zathura
RUN apt-get -y install zathura
RUN mkdir -p ~/.config/zathura
RUN ln -s $WORKBOX_DIR/zathurarc ~/.config/zathura/zathurarc

# Tmux
RUN apt-get install -yq tmux
RUN ln -s $WORKBOX_DIR/tmux.conf ~/.tmux.conf

# Julia
RUN apt-get install -yq julia
RUN julia -e 'using Pkg; Pkg.add(["UpdateJulia"])'
RUN julia -e 'using UpdateJulia; update_julia() '
RUN julia requirements.jl
RUN mkdir -p ~/.julia/config
RUN ln -s $WORKBOX_DIR/startup.jl ~/.julia/config/startup.jl

# NEOVIM
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get -y update
RUN apt-get -y install neovim
RUN apt-get -y install curl
RUN apt-get -y update

ARG NODE_VERSION=16
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y && \
    curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - && \
    apt-get install -y nodejs

RUN mkdir -p ~/.config/nvim/ && touch ~/.config/nvim/init.vim && echo "source ~/workbox/vim_setup/init.vim" >> ~/.config/nvim/init.vim
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qall
RUN nvim +'CocInstall -sync coc-julia coc-jedi coc-json' +qall
RUN nvim +CocUpdateSync +qall


# Paraview
RUN apt-get install -yq paraview


# For regular code
RUN mkdir -p $HOME_DIR/code
ENV WORK_DIR $HOME_DIR/code
WORKDIR $WORK_DIR


