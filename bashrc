#!/bin/bash

set bell-style none
export DISPLAY=:0 #set display for VcXsrv
export VISUAL=nvim
export EDITOR=nvim
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"
export LC_ALL=C.UTF-8

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

# scripted behavior
if command -v navi &> /dev/null; then source <(echo "$(navi widget bash)"); fi

if [ -f ~/dotfiles/assets/aliases ]; then source ~/dotfiles/assets/aliases; fi

if [[ -z "$TMUX" && ("$SSH_CONNECTION" != "" || -n "$PS1") && -z "$NOTES" && -z "$SSHCON"  && -z "$DIARY" ]]; then
    initbash;
elif [ ! -z "$START_VIM" ]; then
    eval "nvim"
elif [ ! -z "$NOTES" ]; then
    eval "nvim -c VimwikiIndex"
elif [ ! -z "$DIARY" ]; then
    eval "nvim -c VimwikiMakeDiaryNote"
elif [ ! -z "$SSHCON" ]; then
    source ~/scripts/bash/ssh_connector.sh
fi

# key binds
bind -x '"\e[21~": "sudo htop"' #bind to F10
bind -x '"\C-b": "cd .."'
bind -x '"\C-h": "cd ~/"'
bind -x '"\C-t": "tx"'
bind -x '"\C-n": "notes"'
bind '"\C-g": "git add . && git commit -m \"\""'
bind -x '"\C-p": fzf-file-widget'
bind -x '"\C-e": `__fzf_cd__`'
bind -x '"\C-r": __fzf_history__'
bind -x '"\C-l": clear'
bind -x '"\C-y": "_call_navi"'

# modified prompt
PS1=$'${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] : \
\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " \xc2\xbb \[\033[01;31m\]%s")\
\[\033[00m\] \xc2\xbb '
