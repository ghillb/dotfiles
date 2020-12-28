#!/bin/bash
dfdir=$HOME/.files
if ! command -v git &> /dev/null; then sudo apt install -y git; fi
git clone https://github.com/ghillb/dotfiles.git $dfdir

declare -a configs=( "os_up" "df" "completion" "nvim" "tmux" "fzf" "spectrwm" "alacritty" "kitty" )
declare -A deploy
for c in "${configs[@]}"; do echo "add [$c] config? (y / → n)"; read -s ans; deploy[$c]=$ans; done

execute() {
  if [[ ${deploy["os_up"]} == "y" ]]; then os_up; fi
  if [[ ${deploy["nvim"]} == "y" ]]; then nvim; fi
  if [[ ${deploy["tmux"]} == "y" ]]; then tmux; fi
  if [[ ${deploy["fzf"]} == "y" ]]; then fzf; fi
  if [[ ${deploy["spectrwm"]} == "y" ]]; then spectrwm; fi
  if [[ ${deploy["alacritty"]} == "y" ]]; then alacritty; fi
  if [[ ${deploy["kitty"]} == "y" ]]; then kitty; fi
  if [[ ${deploy["df"]} == "y" ]]; then df; fi
  if [[ ${deploy["completion"]} == "y" ]]; then completion; fi
}

os_up() {
  sudo apt update && sudo apt upgrade -y;
}

df() {
  sudo apt install -y fonts-firacode ttf-ancient-fonts
  echo -e "# my dotfile additions\n. '$dfdir/bashrc'\n" >> ~/.bashrc
  cp $dfdir/assets/dircolors ~/.dircolors
  ln -s $dfdir/inputrc ~/.inputrc
  ln -s $dfdir/assets/us_keys_caps_mod /usr/share/X11/xkb/symbols/us_keys_caps_mod
  echo "setxkbmap -layout us_keys_caps_mod -option lv3:caps_switch" >> ~/.profile
  # echo ". '$dfdir/assets/startup.sh'" >> ~/.profile
}

completion() {
  echo -e "# additional completions\n. '$dfdir/assets/completion.sh'" >> ~/.bashrc
}

nvim() {
  sudo snap install nvim --classic --edge
  mkdir -p ~/.config/nvim; ln -s $dfdir/vimrc ~/.config/nvim/init.vim
}

tmux() {
  if ! command -v tmux &> /dev/null; then sudo apt install -y tmux; fi
  ln -s $dfdir/tmux.conf ~/.tmux.conf
}

fzf() {
  if ! command -v ag &> /dev/null; then sudo apt install -y silversearcher-ag; fi
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install
}

spectrwm() {
  ln -s $dfdir/spectrwm.conf ~/.spectrwm.conf
}

alacritty() {
  mkdir -p ~/.config/alacritty; ln -s $dfdir/alacritty.yml ~/.config/alacritty/alacritty.yml
}

kitty() {
  mkdir -p ~/.config/kitty; ln -s $dfdir/kitty.conf ~/.config/kitty/kitty.conf
}

execute

