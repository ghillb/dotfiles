#!/bin/bash

set bell-style none
export DISPLAY=:0 #set display for VcXsrv
export VISUAL=vim
export EDITOR=vim
export PATH="$PATH:~/.local/bin:~/.cargo/bin"
export LC_ALL=C.UTF-8
source <(echo "$(navi widget bash)")

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
    cd ~/dotfiles; git pull; cd; tx;
}

## aliases
alias s='sudo '
alias up='sudo apt update && sudo apt upgrade'
alias cd='cdls'
alias mv='mv -i'
alias v='nvim -p'
alias n='navi'
alias py='python3'
alias jn='jupyter notebook'
alias g='git'
alias in='sudo apt install'
alias un='sudo apt remove'
alias gl='git log --all --graph --oneline'
alias gs='git status -s'
alias gd='git diff'
alias gf='git fetch'
alias gps='git push'
alias gpl='git pull'
alias hist='history|grep'
alias wget='wget --hsts-file ~/.config/wget/wget-hsts'
alias code='codium'
alias c='code'
alias notes='nvim -c VimwikiIndex'

## key binds
bind -x '"\e[21~": "sudo htop"' #bind to F10
bind -x '"\C-b": "cd .."'
bind -x '"\C-h": "cd ~/"'
bind -x '"\C-t": "tx"'
bind -x '"\C-n": "notes"'
bind '"\C-g": "git add . && git commit -m \"\" && git push"'
bind -x '"\C-p": fzf-file-widget'
bind -x '"\C-e": `__fzf_cd__`'
bind -x '"\C-r": __fzf_history__'
bind -x '"\C-l": clear'
bind -x '"\C-y": "_call_navi"'

## scripted behavior
if [[ -z "$TMUX" && ("$SSH_CONNECTION" != "" || -n "$PS1") && -z "$NOTES" && -z "$SSHCON" ]]; then
    initbash;
elif [ ! -z "$START_VIM" ]; then
    eval "nvim"
elif [ ! -z "$NOTES" ]; then
    eval "nvim -c VimwikiIndex"
elif [ ! -z "$SSHCON" ]; then
    source ~/scripts/bash/ssh_connector.sh
fi

## modified prompt
PS1=$'${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] : \[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " \xe1\x9b\x98 \[\033[01;31m\]%s")\[\033[00m\] \xe2\x9e\xa4 '
