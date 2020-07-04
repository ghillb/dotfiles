#!/bin/bash
declare -a configs=( "vim" "tmux" "spectrwm" "alacritty" "termite" "color" "embed")
declare -A deploy
for i in "${configs[@]}"; do echo "deploy $i config? (y / → n)";	read -s ans; deploy[$i]=$ans; done

execute() {
  if [[ ${deploy["embed"]} == "y" ]]; then embed; fi
  if [[ ${deploy["vim"]} == "y" ]]; then vim; fi
  if [[ ${deploy["tmux"]} == "y" ]]; then tmux; fi
  if [[ ${deploy["spectrwm"]} == "y" ]]; then spectrwm; fi
  if [[ ${deploy["alacritty"]} == "y" ]]; then alacritty; fi
  if [[ ${deploy["termite"]} == "y" ]]; then termite; fi
  if [[ ${deploy["color"]} == "y" ]]; then color; fi
}

embed() {
  echo -e "# my dotfile additions\n. '$HOME/dotfiles/bashrc'" >> ~/.bashrc
  # echo ". '$HOME/dotfiles/assets/startup.sh'" >> ~/.profile
  mkdir -p ~/.local/share/fonts; ln -s ~/dotfiles/assets/Cascadia.ttf ~/.local/share/fonts/Cascadia.ttf
}

vim() {
  mkdir -p ~/.config/nvim ~/.vim/undodir ; ln -s ~/dotfiles/vimrc ~/.config/nvim/init.vim
	echo "Installing Vim-Plug ..."
	sleep 2
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

tmux() {
  ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
}

spectrwm() {
  ln -s ~/dotfiles/spectrwm.conf ~/.spectrwm.conf
}

alacritty() {
  mkdir -p ~/.config/alacritty; ln -s ~/dotfiles/alacritty.yml ~/.config/alacritty/alacritty.yml
}

termite() {
  mkdir -p ~/.config/termite; ln -s ~/dotfiles/termite.conf ~/.config/termite/config
}

color() {
  echo "Starting Gogh to pick a color theme ..."
  sleep 2
  bash -c  "$(wget -qO- https://git.io/vQgMr)" 
}

execute
