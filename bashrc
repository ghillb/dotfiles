## settings

set bell-style none
export DISPLAY=:0 #set display for VcXsrv

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

alias sudo='sudo '
alias cd="cdls"
alias vim="vim -p"
alias vi="vim -p"
alias v="vim -p"
alias py="python3"

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
