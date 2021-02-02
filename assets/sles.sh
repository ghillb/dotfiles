#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/ghillb/dotfiles/master/assets/sles.sh)

dfdir=$HOME/.files

declare -a configs=( "os_up" "df" "completion" "vim" "tmux" "fzf" )
declare -A deploy
for c in "${configs[@]}"; do echo "add [$c] config? (y / → n)"; read -s ans; deploy[$c]=$ans; done

execute() {
  if [[ ${deploy["os_up"]} == "y" ]]; then os_up; fi
  if [[ ${deploy["df"]} == "y" ]]; then df; fi
  if [[ ${deploy["completion"]} == "y" ]]; then completion; fi
  if [[ ${deploy["vim"]} == "y" ]]; then vim; fi
  if [[ ${deploy["tmux"]} == "y" ]]; then tmux; fi
  if [[ ${deploy["fzf"]} == "y" ]]; then fzf; fi
}

os_up() {
  sudo zypper up;
  sudo zypper install -y git
  git clone https://github.com/ghillb/dotfiles.git $dfdir
}

df() {
  echo -e "# my dotfile additions\n. '$dfdir/bashrc'\n" >> ~/.bashrc
  ln -sf $dfdir/assets/dircolors ~/.dircolors
  ln -sf $dfdir/assets/inputrc ~/.inputrc
}

completion() {
  echo -e "# additional completions\n. '$dfdir/assets/completion.sh'" >> ~/.bashrc
}

vim() {
  sudo zypper addrepo https://download.opensuse.org/repositories/editors/SLE_15/editors.repo
  sudo zypper refresh
  sudo zypper remove vim
  sudo zypper install vim
  ln -sf $dfdir/vimrc ~/.vimrc
}

tmux() {
  sudo zypper addrepo https://download.opensuse.org/repositories/utilities/SLE_15_SP2/utilities.repo
  sudo zypper refresh
  sudo zypper install tmux
  ln -sf $dfdir/tmux.conf ~/.tmux.conf
}

fzf() {
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install
}

execute

