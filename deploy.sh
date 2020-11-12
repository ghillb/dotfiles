#!/bin/bash
dfdir=$HOME/.files
git clone https://github.com/ghillb/dotfiles.git $dfdir

declare -a configs=( "os_up" "df" "nvim" "tmux" "fzf" "spectrwm" "alacritty" "termite" )
declare -A deploy
for c in "${configs[@]}"; do echo "add [$c] config? (y / → n)"; read -s ans; deploy[$c]=$ans; done

execute() {
  if [[ ${deploy["os_up"]} == "y" ]]; then os_up; fi
  if [[ ${deploy["nvim"]} == "y" ]]; then nvim; fi
  if [[ ${deploy["tmux"]} == "y" ]]; then tmux; fi
  if [[ ${deploy["fzf"]} == "y" ]]; then fzf; fi
  if [[ ${deploy["spectrwm"]} == "y" ]]; then spectrwm; fi
  if [[ ${deploy["alacritty"]} == "y" ]]; then alacritty; fi
  if [[ ${deploy["termite"]} == "y" ]]; then termite; fi
  if [[ ${deploy["df"]} == "y" ]]; then df; fi
}

os_up() {
  sudo apt update && sudo apt upgrade -y;
}

df() {
  echo -e "# my dotfile additions\n. '$dfdir/bashrc'" >> ~/.bashrc
  ln -s $dfdir/inputrc ~/.inputrc
  cp $dfdir/assets/dircolors ~/.dircolors
  # echo ". '$HOME/dotfiles/assets/startup.sh'" >> ~/.profile
  # mkdir -p ~/.local/share/fonts; ln -s $dfdir/assets/Fira.ttf ~/.local/share/fonts/Fira.ttf
}

nvim() {
  sudo snap install nvim --classic --edge
  if ! command -v ag &> /dev/null; then sudo apt install -y silversearcher-ag; fi
  mkdir -p ~/.config/nvim; ln -s $dfdir/vimrc ~/.config/nvim/init.vim
  cp $dfdir/assets/coc-settings.json ~/.config/nvim/
}

tmux() {
  if ! command -v tmux &> /dev/null; then sudo apt install -y tmux; fi
  ln -s $dfdir/tmux.conf ~/.tmux.conf
}

fzf() {
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install
}

spectrwm() {
  ln -s $dfdir/spectrwm.conf ~/.spectrwm.conf
}

alacritty() {
  mkdir -p ~/.config/alacritty; ln -s $dfdir/alacritty.yml ~/.config/alacritty/alacritty.yml
}

termite() {
  mkdir -p ~/.config/termite; ln -s $dfdir/termite.conf ~/.config/termite/config
}

execute

