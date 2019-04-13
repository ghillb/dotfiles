## settings

set bell-style none

## functions

cdls()
{
    cd $1 && ls;
}

iploc()
{
    curl ipinfo.io/"$1" ; echo
}

tx()
{
    if [ -z "$*" ] ; then
        tmux attach || tmux new;
    else
        tmux "$1";
    fi
}

initbash()
{
    echo "1. Updating configuration...";
    cd ~/dotfiles;
    git pull;
    echo "2. Starting tmux...";
    sleep 1;
    cd ~/;
    tx;
}

## aliases

alias cd="cdls"
alias vim="vim -p"
alias vi="vim -p"
alias v="vim -p"

## key binds

bind -x '"\e[21~": "sudo htop"' # bind to F10
bind -x '"\C-b": "cd .."'
bind -x '"\C-h": "cd ~/"'
bind -x '"\C-t": "tx"'
bind -x '"\C-e": "ranger"'
bind -x '"\C-j": "jupyter-notebook"'
bind '"\C-g": "git add . && git commit -m \"\" && git push"'
