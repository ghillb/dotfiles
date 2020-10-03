#!/bin/bash

set bell-style none
export DISPLAY=:0 #set display for VcXsrv
export VISUAL=nvim
export EDITOR=nvim
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin"
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
        tmux -2 attach -t $USER || tmux -2 new -s $USER;
    else
        tmux -2 "$1";
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

vdiff () {
    if [ "$#" -ne 2 ] ; then
        echo "vdiff requires two arguments"
        echo "  comparing dirs:  vdiff dir_a dir_b"
        echo "  comparing files: vdiff file_a file_b"
        return 1
    fi

    local left="${1}"
    local right="${2}"

    if [ -d "${left}" ] && [ -d "${right}" ]; then
        nvim +"DirDiff ${left} ${right}"
    else
        nvim -d "${left}" "${right}"
    fi
}

# scripted behavior
if command -v navi &> /dev/null; then source <(echo "$(navi widget bash)"); fi

if [ -f ~/dotfiles/assets/aliases ]; then source ~/dotfiles/assets/aliases; fi

if [[ -z "$TMUX" && ("$SSH_CONNECTION" != "" || -n "$PS1") &&\
    -z "$NOTES" && -z "$SSHCON"  && -z "$DIARY" ]]; then initbash;
elif [ ! -z "$START_VIM" ]; then
    eval "nvim"
elif [ ! -z "$NOTES" ]; then
    eval "nvim -c VimwikiIndex +'cd %:h'"
elif [ ! -z "$DIARY" ]; then
    eval "nvim -c 'let g:startify_disable_at_vimenter = 1' +VimwikiMakeDiaryNote +'cd %:h'"
elif [ ! -z "$SSHCON" ]; then
    source ~/scripts/bash/ssh_connector.sh
elif [ ! -z "$WORK_DIR" ]; then
    cd "$(wslpath -a "${WORK_DIR}")"
fi

# key binds
bind -x '"\C-b": "cd .."'
bind -x '"\C-h": "cd ~/"'
bind -x '"\C-t": "tx"'
bind -x '"\C-n": "notes"'
bind -x '"\C-p": fzf-file-widget'
bind -x '"\C-e": `__fzf_cd__`'
bind -x '"\C-r": __fzf_history__'
bind -x '"\C-o": "_call_navi"'
bind -x '"\C-l": clear'
bind -x '"\C-y": fg'
bind -x '"\e[21~": "htop"' #F10
bind '"\C-g": "git add . && git commit -m \"\""'
bind '"\t":menu-complete'
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"
bind "set menu-complete-display-prefix on"

# modified prompt
PS1=$'${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] : \
\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " : \[\033[01;31m\]%s")\
\[\033[00m\]\n\xe2\xae\x9e '

