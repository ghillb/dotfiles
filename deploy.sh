#!/bin/bash
declare -a configs=( "df" "vim" "tmux" "fzf" "spectrwm" "alacritty" "termite" )
declare -A deploy
for c in "${configs[@]}"; do echo "add [$c] config? (y / → n)"; read -s ans; deploy[$c]=$ans; done

execute() {
  if [[ ${deploy["df"]} == "y" ]]; then df; fi
  if [[ ${deploy["vim"]} == "y" ]]; then vim; fi
  if [[ ${deploy["tmux"]} == "y" ]]; then tmux; fi
  if [[ ${deploy["fzf"]} == "y" ]]; then fzf; fi
  if [[ ${deploy["spectrwm"]} == "y" ]]; then spectrwm; fi
  if [[ ${deploy["alacritty"]} == "y" ]]; then alacritty; fi
  if [[ ${deploy["termite"]} == "y" ]]; then termite; fi
}

df() {
  echo -e "# my dotfile additions\n. '$HOME/dotfiles/bashrc'" >> ~/.bashrc
  ln -s dotfiles/inputrc .inputrc
  cp ~/dotfiles/assets/dircolors ~/.dircolors
  # echo ". '$HOME/dotfiles/assets/startup.sh'" >> ~/.profile
  mkdir -p ~/.local/share/fonts; ln -s ~/dotfiles/assets/Cascadia.ttf ~/.local/share/fonts/Cascadia.ttf
}

vim() {
  if ! command -v nvim &> /dev/null; then sudo apt install -y neovim; fi
  if ! command -v ag &> /dev/null; then sudo apt install -y silversearcher-ag; fi
  mkdir -p ~/.config/nvim ~/.vim/undodir ; ln -s ~/dotfiles/vimrc ~/.config/nvim/init.vim
  cp ~/dotfiles/assets/coc-settings.json ~/.config/nvim/
  echo "Installing Vim-Plug ..."
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

tmux() {
  if ! command -v tmux &> /dev/null; then sudo apt install -y tmux; fi
  ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
}

fzf() {
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install
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

execute
