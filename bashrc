#!/bin/bash
## settings
set bell-style none
export DISPLAY=:0 #set display for VcXsrv
export VISUAL=vim #set vim as default editor
export EDITOR=vim
export PATH="$PATH:~/.local/bin" #add user bin to path
export LC_ALL=C.UTF-8

## functions
cdls()
{
    cd "$@" && ls;
}

iploc()
{
    curl ipinfo.io/"$1" ; echo
}

tx()
{
    if [ -z "$*" ] ; then
        tmux attach -t $USER || tmux new -s $USER;
    else
        tmux "$1";
    fi
}

repeat() 
{
    n=$1
    shift
    while [ $(( n -= 1 )) -ge 0 ]
    do
        "$@"
    done
}

initbash()
{
    cd ~/dotfiles; git pull; cd;#tx;
}

## aliases
alias s='sudo '
alias up='sudo apt update && sudo apt upgrade'
alias cd='cdls'
alias mv='mv -i'
alias v='nvim -p'
alias n='nano'
alias py='python3'
alias jn='jupyter notebook'
alias n='nano'
alias g='git'
alias in='sudo apt install'
alias un='sudo apt remove'
alias gl='git log --all --graph --oneline'
alias gs='git status -s'
alias gd='git diff'
alias hist='history|grep'
alias wget='wget --hsts-file ~/.config/wget/wget-hsts'
alias code='codium'
alias c='code'

## key binds
bind -x '"\e[21~": "sudo htop"' #bind to F10
bind -x '"\C-b": "cd .."'
bind -x '"\C-h": "cd ~/"'
bind -x '"\C-t": "tx"'
bind -x '"\C-e": "sudo ranger"'
bind '"\C-g": "git add . && git commit -m \"\" && git push"'

## scripted behaviour
if [[ -z "$TMUX" && ("$SSH_CONNECTION" != "" || -n "$PS1") ]]; then
    initbash #run initbash on shell init or ssh connection
fi

## modified prompt
PS1=$'${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] : \[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " \xe2\x88\xb4 \[\033[01;31m\]%s")\[\033[00m\] \xe2\x86\x92 '
