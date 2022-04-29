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
alias zbg="zathura main.pdf &>/dev/null &"
alias pbg="paraview &>/dev/null &"
alias so="source ~/.bashrc"
alias f="fg"
alias w="cd ~/workbox"
alias r="ranger"
alias e="exit"

alias juplab="jupyter-lab --ip 0.0.0.0 --port 8888 --allow-root"

# Basic git aliases
function git_clone_recursive()  {
    arg=$1
    git clone $arg --recurse-submodules
}

function git_commit()  {
    array="${@}"
    git commit -m"$array"
}

function git_stash_pop()  {
    arg=$1
    git stash pop stash@{$arg}
}

function get_file_from_commit() {
    commit_id=$1
    file_path=$2
    git checkout $commit_id -- $file_path
}
function set_git_global_user() {
    email=$1
    git config --global user.email "$email"
}
# Git aliases
alias gl="git log"
alias gd="git diff"
alias gqp="git stash pop"
alias gq="git stash"
alias gs="git status"
alias gb="git branch"
alias gch="git checkout"
alias gchb="git checkout -b"
alias ga="git add"
alias gap="git add -p"
alias gc="git_commit" # custom function
alias gce="git commit -a --allow-empty-message -m ''"
alias gp="git push origin HEAD"
alias gpu="git pull"
alias sgg="set_git_global_user"



# Sample prompt declaration based off of the default Ubuntu 14.04.1 color
# prompt. Tweak as you see fit, or just stick "$(git_prompt)" into your
# favorite prompt.
# Shorten the dir names,
sps() {
    echo `dirname $PWD` | sed -r 's|/(.)[^/]*|/\1|g'
}
PS1="$debian_chroot\[\033[03;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\] $(eval "sps")/\W\[\033[00m\]\$ "

echo "cd ~/code" && cd ~/code
