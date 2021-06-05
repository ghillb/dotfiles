#!/bin/bash

dfdir=$HOME/.files
confdir=$HOME/.config
sudo apt update && sudo apt upgrade -y;
sudo apt install -y git build-essential
git clone https://github.com/ghillb/dotfiles.git $dfdir

declare -a configs=( "df" "nvim" "tmux" "fzf" "utils" "desktop" )
declare -A deploy
for c in "${configs[@]}"; do echo "add [$c] config? (y / → n)"; read -s ans; deploy[$c]=$ans; done

execute() {
  if [[ ${deploy["nvim"]} == "y" ]]; then nvim; fi
  if [[ ${deploy["tmux"]} == "y" ]]; then tmux; fi
  if [[ ${deploy["fzf"]} == "y" ]]; then fzf; fi
  if [[ ${deploy["df"]} == "y" ]]; then df; fi
  if [[ ${deploy["utils"]} == "y" ]]; then utils; fi
  if [[ ${deploy["desktop"]} == "y" ]]; then desktop; fi
}

df() {
  echo -e "source '$dfdir/configs/bashrc'\n" >> $HOME/.bashrc
  ln -sf $dfdir/assets/dircolors $HOME/.dircolors
  ln -sf $dfdir/assets/inputrc $HOME/.inputrc
  sudo ln -sf $dfdir/shell/coderun.sh /usr/local/bin/cr
}

nvim() {
  mkdir -p ~/.config/nvim; ln -sf $dfdir/vim/vimrc $confdir/nvim/init.vim
  ln -sf $dfdir/vim/vimrc $HOME/.vimrc
}

tmux() {
  if ! command -v tmux &> /dev/null; then sudo apt install -y tmux; fi
  ln -sf $dfdir/configs/tmux.conf $HOME/.tmux.conf
}

fzf() {
  if ! command -v ag &> /dev/null; then sudo apt install -y silversearcher-ag; fi
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf; $HOME/.fzf/install --all
}

utils() {
  sudo apt install -y sshfs jq curl shellcheck ncdu gcc make perl
}

desktop() {
  sudo apt install -y spectrwm fonts-firacode ttf-ancient-fonts picom feh xdotool wmctrl xsel rofi kitty nnn zathura
  git clone https://github.com/bardisty/gruvbox-rofi ~/.config/rofi/themes/gruvbox
  cd $confdir; mkdir -p spectrwm rofi gtk-3.0 alacritty kitty
  ln -sf $dfdir/configs/spectrwm.conf $confdir/spectrwm/spectrwm.conf
  ln -sf $dfdir/configs/rofi.conf $confdir/rofi/config
  ln -sf $dfdir/configs/starship.toml $confdir/starship.toml
  ln -sf $dfdir/configs/alacritty.yml $confdir/alacritty/alacritty.yml
  ln -sf $dfdir/configs/kitty.conf $confdir/kitty/kitty.conf
  ln -sf $dfdir/assets/mimeapps.list $confdir/mimeapps.list
  sudo ln -sf $dfdir/shell/dopen.sh /usr/local/bin/dopen
  sudo ln -sf $dfdir/shell/detach.sh /usr/local/bin/detach
  sudo ln -sf $dfdir/shell/float_term.sh /usr/local/bin/float_term
  sudo ln -sf $dfdir/assets/ansi_hybrid /usr/share/X11/xkb/symbols/ansi_hybrid
  sudo ln -sf $dfdir/assets/nvim-terminal.desktop /usr/share/applications/nvim-terminal.desktop
  sudo ln -sf $dfdir/assets/nnn-terminal.desktop /usr/share/applications/nnn-terminal.desktop
  echo "eval \$(ssh-agent); setxkbmap -layout ansi_hybrid -variant 5layer; exec spectrwm" >> $HOME/.xprofile
}

execute

