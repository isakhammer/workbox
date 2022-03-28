#!/usr/bin/env bash

mkdir -p ~/.config/nvim/ && touch ~/.config/nvim/init.vim && echo "source ~/workbox/vim_setup/init.vim" >> ~/.config/nvim/init.vim

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim --headless +PlugInstall +qall

nvim +'CocInstall -sync coc-julia coc-jedi coc-json' +qall
nvim +CocUpdateSync +qall
