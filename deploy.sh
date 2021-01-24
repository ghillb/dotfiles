#!/bin/bash
dfdir=$HOME/.files
if ! command -v git &> /dev/null; then sudo apt install -y git; fi
git clone https://github.com/ghillb/dotfiles.git $dfdir

declare -a configs=( "os_up" "df" "completion" "nvim" "tmux" "fzf" "desktop" "alacritty" "kitty" )
declare -A deploy
for c in "${configs[@]}"; do echo "add [$c] config? (y / → n)"; read -s ans; deploy[$c]=$ans; done

execute() {
  if [[ ${deploy["os_up"]} == "y" ]]; then os_up; fi
  if [[ ${deploy["nvim"]} == "y" ]]; then nvim; fi
  if [[ ${deploy["tmux"]} == "y" ]]; then tmux; fi
  if [[ ${deploy["fzf"]} == "y" ]]; then fzf; fi
  if [[ ${deploy["desktop"]} == "y" ]]; then desktop; fi
  if [[ ${deploy["alacritty"]} == "y" ]]; then alacritty; fi
  if [[ ${deploy["kitty"]} == "y" ]]; then kitty; fi
  if [[ ${deploy["df"]} == "y" ]]; then df; fi
  if [[ ${deploy["completion"]} == "y" ]]; then completion; fi
}

os_up() {
  sudo apt update && sudo apt upgrade -y;
}

df() {
  echo -e "# my dotfile additions\n. '$dfdir/bashrc'\n" >> ~/.bashrc
  ln -s $dfdir/assets/dircolors ~/.dircolors
  ln -s $dfdir/assets/inputrc ~/.inputrc
}

completion() {
  echo -e "# additional completions\n. '$dfdir/assets/completion.sh'" >> ~/.bashrc
}

nvim() {
  if ! command -v nvim &> /dev/null; then sudo apt install -y neovim; fi
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

desktop() {
  sudo apt install -y spectrwm fonts-firacode ttf-ancient-fonts picom feh
  ln -s $dfdir/spectrwm.conf ~/.spectrwm.conf
  ln -s $dfdir/rofi.conf ~/.config/rofi/config
  sudo ln -s $dfdir/assets/xopener /usr/local/bin/xopener
  sudo ln -s $dfdir/assets/executer /usr/local/bin/executer
  sudo ln -s $dfdir/invnnn /usr/local/bin/invnnn
  sudo ln -s $dfdir/assets/dopen /usr/local/bin/dopen
  sudo ln -s $dfdir/assets/ansi_hybrid /usr/share/X11/xkb/symbols/ansi_hybrid
  sudo ln -s $dfdir/assets/nvim-terminal.desktop /usr/share/applications/nvim-terminal.desktop
  sudo ln -s $dfdir/assets/nnn-terminal.desktop /usr/share/applications/nnn-terminal.desktop
  echo "setxkbmap -layout ansi_hybrid -variant 5layer" >> ~/.profile
}

alacritty() {
  mkdir -p ~/.config/alacritty; ln -s $dfdir/alacritty.yml ~/.config/alacritty/alacritty.yml
}

kitty() {
  mkdir -p ~/.config/kitty; ln -s $dfdir/kitty.conf ~/.config/kitty/kitty.conf
}

execute

