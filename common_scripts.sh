alias p3='python3.8'
alias python='python3.8'

#shopt
shopt -s autocd # change to named directory
shopt -s cdspell # autocorrects cd misspellings
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend # do not overwrite history
shopt -s expand_aliases # expand aliases

export EDITOR="nvim"
export READER="zathura"


# vi mode
set -o vi
export KEYTIMEOUT=1
alias c="clear"
alias vim="nvim"
alias ls="ls --color=auto"
alias zathura_bg="zathura main.pdf &>/dev/null &"
alias so="source ~/.bashrc"
alias f="fg"
alias w="cd ~/workbox"


alias juplab="jupyter-lab --ip 0.0.0.0 --port 8888 --allow-root"

