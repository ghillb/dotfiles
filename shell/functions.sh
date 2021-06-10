#!/bin/sh

cdls() {
  cd "$@" && ls;
}

iploc() {
  curl ipinfo.io/"$1" ; echo
}

tx() {
  if [ -z "$*" ] ; then
    tmux -2 attach -t $USER || tmux -2 new -s $USER;
  elif [ $1 == "kitty-float" ]; then
    tmux -2 attach -t $1 || tmux -2 new -s $1;
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

gsubrm() {
  git submodule deinit -f -- "$1" && git rm -f "$1" && rm -rf .git/modules/"$1"
}

notes() {
  eval "nvim -c VimwikiIndex +'cd %:h'"
}

diary() {
  eval "nvim -c 'let g:startify_disable_at_vimenter = 1' +VimwikiMakeDiaryNote +'cd %:h'"
}

function_exists() {
  test x$(type -t $1) = xfunction
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

m() {
  if [ $# -eq 0 ]; then 
    echo "What manual page do you want?"
  elif command -v nvim &> /dev/null; then
    nvim <(/usr/bin/man $*) -Rm \
      --cmd 'filetype plugin on' \
      -c 'set ft=man' \
      -c 'set ls=0' \
      -c 'set cc=' \
      -c 'map q :q!<cr>' \
      -c 'autocmd!'
  else
    LESS_TERMCAP_md=$'\e[01;36m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;40;31m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;33m' \
    command man "$@"
  fi
}

epoch2utc () {
  date -d @"${1}"
}

hash_docker_image() {
  docker create $1 | {
    read cid
    docker export $cid | tar Oxv 2>&1 | shasum -a 256
    docker rm $cid > /dev/null
  }
}

fzkill() {
  ps -ef | fzf --height=40% | awk '{print $2}' | xargs kill -9
}

kubemerge() {
 DATE=$(date +"%Y%m%d%H%M")
 KUBECONFIG=~/.kube/config:$1 \
   kubectl config view --flatten > ~/.kube/merged \
   && mv ~/.kube/config ~/.kube/config-$DATE \
   && mv ~/.kube/merged ~/.kube/config \
   && chmod 600 ~/.kube/config
}

xed() {
  nvim $(which $1)
}

