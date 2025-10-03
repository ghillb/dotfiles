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
  else
    tmux -2 "$1";
  fi
}

sshsel() {
  local server
  server=$(grep -E '^Host ' ~/.ssh/config | awk '{print $2}' | grep -v '\*' | tac | fzf --prompt="SSH > " --height=40% --reverse)
  if [[ -n $server ]]; then
    ssh $server
  fi
}

include () {
  [[ -f "$1" ]] && source "$1"
}

initbash() {
  if ping -q -w 1 -c 1 1.1.1.1 > /dev/null; then git -C $DOTFILES pull; fi; tx
}

gsubrm() {
  git submodule deinit -f -- "$1" && git rm -f "$1" && rm -rf .git/modules/"$1"
}

notes() {
  eval "nvim -c VimwikiIndex +'cd %:h' +\"call timer_start(5, { tid -> execute('Telescope live_grep')})\""
}

nvim_project_picker() {
  eval "nvim -c \"call timer_start(5, { tid -> execute('Telescope project display_type=full')})\""
}

fzf_project_picker () {
  cd $(find $HOME/code -name .git -type d -prune | fzf)/..
  include .envrc
  eval "nvim -c \"call timer_start(5, { tid -> execute('Telescope find_files')})\""
}

diary() {
  eval "nvim +VimwikiMakeDiaryNote +'cd %:h'"
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

find_function()( shopt -s extdebug; declare -F "$@"; )

ped() {
  if $(function_exists $1) || false ; then
    FILE_PATH=$(find_function $1 | awk '{print $3}')
    LINE_POS=$(find_function $1 | awk '{print $2}')
  else
    FILE_PATH=$(which $1)
  fi
  nvim +$LINE_POS $FILE_PATH
}

ns() {
  grep -C 5 "$*" ~/.notes/* -r --exclude-dir={html,resources};
}

gitignore() {
  git_root=$(git rev-parse --show-toplevel)
  gitignore_file="$git_root/.gitignore"

  if [ ! -f "$gitignore_file" ]; then
    echo "Warning: .gitignore file does not exist."
    read -p "Do you want to create one? (y/n): " create_gitignore
    if [ "$create_gitignore" != "y" ]; then
      echo "Aborting."
      return
    else
      touch "$gitignore_file"
      echo ".gitignore file created."
    fi
  fi

  if ! grep -qxF "$1" "$gitignore_file"; then
    echo "$1" >> "$gitignore_file"
    echo "$1 added to .gitignore."
  else
    echo "$1 is already in .gitignore."
  fi
}

_git_commit_with_msg() {
    nvim --headless -c "CommitMsgCLI"
    READLINE_LINE='git commit -m ""'
    READLINE_POINT=$((${#READLINE_LINE} - 1))
}