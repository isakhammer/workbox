FROM ubuntu:24.04
LABEL maintainer="Isak Hammer"

SHELL ["/bin/bash", "-c"]

ENV TZ=Europe/Oslo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV HOME_DIR=/root

# Terminal editing, PDF viewing, and Python.
ARG DEBIAN_FRONTEND=noninteractive
ARG WORKBOX_EXTRAS=0
ENV PIP_NO_CACHE_DIR=1
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         ca-certificates curl git ripgrep fzf fontconfig \
         python3 python3-pip python3-venv \
         dbus-x11 libglib2.0-bin xclip xdotool xauth ncurses-bin \
         poppler-utils file zathura zathura-pdf-poppler \
         latexmk biber pandoc texlive-latex-extra texlive-bibtex-extra \
         texlive-fonts-recommended texlive-lang-european texlive-science cm-super-minimal \
    && if [ "$WORKBOX_EXTRAS" = 1 ]; then \
         apt-get install -y texlive-full build-essential cmake bc libblas-dev liblapack-dev \
           python3-dev python3-tk libgl1 libglu1-mesa libxmu6 libxi6; \
       fi \
    && rm -rf /var/lib/apt/lists/*

# Create workbox folder and environment variables
RUN mkdir -p $HOME_DIR/workbox
ENV WORKBOX_DIR=$HOME_DIR/workbox
ENV CONFIG_DIR=$WORKBOX_DIR/config
ENV DEP_DIR=$WORKBOX_DIR/dependencies
WORKDIR $WORKBOX_DIR
RUN mkdir $HOME_DIR/.config

# INSTALL WORKBOX

# Copy all files from host to container
COPY . .

# Installing the fonts
### arggh still not able to generate all fonts in julia in vim
RUN mkdir -p $HOME_DIR/.local/share/fonts/
RUN ln -s $DEP_DIR/JuliaMono-Regular.ttf $HOME_DIR/.local/share/fonts/
RUN fc-cache -f -v

# Source common_scripts into .bashrc
RUN echo "source ${WORKBOX_DIR}/common_scripts.sh" >> /root/.bashrc

# Editor and Ranger dependencies, with optional scientific tools.
RUN python3 -m pip install --break-system-packages -r "$DEP_DIR/requirements.txt" \
    && if [ "$WORKBOX_EXTRAS" = 1 ]; then \
         python3 -m pip install --break-system-packages numpy scipy sympy matplotlib pandas ffmpeg-python jupyterlab ipywidgets ngsolve xfem casadi autograd webgui_jupyter_widgets; \
       fi

RUN mkdir -p ~/.config/zathura \
    && ln -s "$CONFIG_DIR/zathurarc" ~/.config/zathura/zathurarc

## Julia
## Install Juliaup
# ENV JULIA_VERSION=1.9.3
ENV JULIA_VERSION=1.8.5

ENV PATH=/root/.local/lib/fzf/bin:/root/.juliaup/bin:$PATH
RUN if [ "$WORKBOX_EXTRAS" = 1 ]; then \
      curl -fsSL https://install.julialang.org -o /tmp/install_julia.sh \
      && sh /tmp/install_julia.sh --yes --default-channel "$JULIA_VERSION" \
      && rm /tmp/install_julia.sh \
      && julia "$DEP_DIR/requirements.jl" \
      && mkdir -p ~/.julia/config \
      && ln -s "$CONFIG_DIR/startup.jl" ~/.julia/config/startup.jl; \
    fi

# Ranger
RUN ln -s $CONFIG_DIR/ranger ~/.config/ranger

# NEOVIM
# Use the official pinned release instead of Launchpad's daily builds.
ARG NVIM_VERSION=v0.12.6
RUN case "$(dpkg --print-architecture)" in \
         amd64) nvim_arch=x86_64; nvim_sha256=474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87 ;; \
         arm64) nvim_arch=arm64; nvim_sha256=8f1f64a0bdb97247034038c3823c6cbad5bdf9ecd5751b85494b71c3ee04c815 ;; \
         *) echo "Unsupported Neovim architecture" >&2; exit 1 ;; \
       esac \
    && curl -fL --retry 5 --retry-all-errors \
       "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-${nvim_arch}.tar.gz" \
       -o /tmp/nvim.tar.gz \
    && echo "$nvim_sha256  /tmp/nvim.tar.gz" | sha256sum --check \
    && mkdir -p /opt/nvim \
    && tar -xzf /tmp/nvim.tar.gz --strip-components=1 -C /opt/nvim \
    && ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim \
    && rm /tmp/nvim.tar.gz

RUN mkdir -p ~/.config/nvim/ && touch ~/.config/nvim/init.vim && echo "source ${CONFIG_DIR}/nvim/init.vim" >> ~/.config/nvim/init.vim
RUN curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless "+PlugInstall --sync" +qall
# Fail the build if the editor and the pinned VimTeX release are incompatible.
RUN nvim --headless /tmp/workbox-vimtex-check.tex \
    -c "if !has('nvim-0.12.4') || !exists('b:vimtex') || maparg('<Bslash>ll', 'n') !=# '<Plug>(vimtex-compile)' || !empty(v:errmsg) | cquit | endif" \
    -c qall

# Dont forget to uncomment vimrc as well
# RUN nvim +'CocInstall -sync coc-julia coc-jedi coc-json' +qall
# RUN nvim +CocUpdateSync +qall
# coc-julia installation
# RUN julia --project="/root/.config/coc/extensions/node_modules/coc-julia/server/JuliaLS" --startup-file=no --history-file=no -e "using Pkg; Pkg.instantiate()"
# RUN julia --project="/root/.config/coc/extensions/node_modules/coc-julia/server/compile_env" --startup-file=no --history-file=no -e "using Pkg; Pkg.instantiate()"
# RUN nvim +'CocCommand julia.CompileLanguageServerSysimg' +qall


# Utilities
#RUN apt-get install -yq inkscape

# FEM libraries
#RUN apt-get install -yq paraview gmsh


# For regular code
RUN mkdir -p $HOME_DIR/code
ENV WORK_DIR=$HOME_DIR/code
WORKDIR $WORK_DIR

# Source after the end of installation
RUN source /root/.bashrc

