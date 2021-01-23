#!/bin/bash

set bell-style none
export TERM=xterm-256color
export DISPLAY=:0 #set display for VcXsrv
export VISUAL=nvim
export EDITOR=nvim
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.go/bin:$HOME/.linuxbrew/bin"
export LC_ALL=C.UTF-8
export GIT_PS1_SHOWDIRTYSTATE=true
export FZF_DEFAULT_OPTS='
  --color fg:#ebdbb2,bg:#282828,hl:#fe8019,fg+:#ebdbb2,bg+:#3c3836,hl+:#d65d0e
  --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#fb4934,marker:#fe8019,header:#665c54
'
export NNN_PLUG='o:fzopen;p:preview-tui'
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_FCOLORS='c1e21f70006048f7c6d6abc4' 
export NNN_BMS=$NNN_BMS_LOCAL'h:~/;c:~/code/;d:~/dl/;n:~/notes/;p:~/projects/;'
export NNN_OPENER='dopen'

cdls() {
    cd "$@" && ls;
}

iploc() {
    curl ipinfo.io/"$1" ; echo
}

tx() {
    if [ -z "$*" ] ; then
        tmux -2 attach -t $USER || tmux -2 new -s $USER;
    else
        tmux -2 "$1";
    fi
}

include () {
    [[ -f "$1" ]] && source "$1"
}

initbash() {
    if ping -q -w 1 -c 1 1.1.1.1 > /dev/null; then git -C $HOME/.files/ pull; fi; tx
}

notes() {
    eval "nvim -c VimwikiIndex +'cd %:h'"
}

diary() {
    eval "nvim -c 'let g:startify_disable_at_vimenter = 1' +VimwikiMakeDiaryNote +'cd %:h'"
}

repeat() {
    n=$1
    shift
    while [ $(( n -= 1 )) -ge 0 ]
    do
        "$@"
    done
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
include /usr/lib/git-core/git-sh-prompt
include ~/.files/assets/aliases
include ~/scripts/bash/ssh_connector.sh
include ~/scripts/bash/utils.sh

if [[ -z "$TMUX" && "$SSH_CONNECTION" != "" ]]; then initbash;
elif [ ! -z "$WORK_DIR" ]; then cd "$(wslpath -a "${WORK_DIR}")"; fi

# key binds
bind -x '"\C-b": "cd .."'
bind -x '"\C-h": "cd ~/"'
bind -x '"\C-t": "tx"'
bind -x '"\C-n": "notes"'
bind -x '"\C-p": fzf-file-widget'
bind -x '"\C-e": `__fzf_cd__`'
bind -x '"\C-r": __fzf_history__'
bind -x '"\C-o": "navi"'
bind -x '"\C-l": clear'
bind -x '"\C-y": fg'
bind -x '"\e[21~": "htop"' #F10
bind '"\C-g": "git commit -am \"\""'
bind '"\t":menu-complete'
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"
bind "set menu-complete-display-prefix on"

# modified prompt
PS1=$'${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] : \
\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " : \[\033[01;31m\]%s")\
\[\033[38;5;207m\]\n\xe2\xae\x9e\[\033[00m\] '

