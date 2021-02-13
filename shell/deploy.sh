#!/bin/bash
dfdir=$HOME/.files
confdir=$HOME/.config
sudo apt install -y git
git clone https://github.com/ghillb/dotfiles.git $dfdir

declare -a configs=( "os_up" "df" "nvim" "tmux" "fzf" "desktop" )
declare -A deploy
for c in "${configs[@]}"; do echo "add [$c] config? (y / → n)"; read -s ans; deploy[$c]=$ans; done

execute() {
  if [[ ${deploy["os_up"]} == "y" ]]; then os_up; fi
  if [[ ${deploy["nvim"]} == "y" ]]; then nvim; fi
  if [[ ${deploy["tmux"]} == "y" ]]; then tmux; fi
  if [[ ${deploy["fzf"]} == "y" ]]; then fzf; fi
  if [[ ${deploy["desktop"]} == "y" ]]; then desktop; fi
  if [[ ${deploy["df"]} == "y" ]]; then df; fi
}

os_up() {
  sudo apt update && sudo apt upgrade -y;
}

df() {
  echo -e "# my dotfile additions\n. '$dfdir/configs/bashrc'\n" >> $HOME/.bashrc
  ln -sf $dfdir/assets/dircolors $HOME/.dircolors
  ln -sf $dfdir/assets/inputrc $HOME/.inputrc
}

nvim() {
  if ! command -v nvim &> /dev/null; then sudo apt install -y neovim; fi
  mkdir -p ~/.config/nvim; ln -s $dfdir/vim/vimrc $confdir/nvim/init.vim
  ln -sf $dfdir/vim/vimrc $HOME/.vimrc
}

tmux() {
  if ! command -v tmux &> /dev/null; then sudo apt install -y tmux; fi
  ln -sf $dfdir/configs/tmux.conf $HOME/.tmux.conf
}

fzf() {
  if ! command -v ag &> /dev/null; then sudo apt install -y silversearcher-ag; fi
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf; $HOME/.fzf/install
}

desktop() {
  sudo apt install -y spectrwm fonts-firacode ttf-ancient-fonts picom feh xdotool
  cd $confdir; mkdir -p spectrwm rofi gtk-3.0 alacritty kitty
  ln -sf $dfdir/configs/spectrwm.conf $confdir/spectrwm/spectrwm.conf
  ln -sf $dfdir/configs/rofi.conf $confdir/rofi/config
  ln -sf $dfdir/configs/starship.toml $confdir/starship.toml
  ln -sf $dfdir/configs/alacritty.yml $confdir/alacritty/alacritty.yml
  ln -sf $dfdir/configs/kitty.conf $confdir/kitty/kitty.conf
  ln -sf $dfdir/assets/gtk-settings.ini $confdir/gtk-3.0/settings.ini
  sudo ln -sf $dfdir/shell/dopen.sh /usr/local/bin/dopen
  sudo ln -sf $dfdir/assets/ansi_hybrid /usr/share/X11/xkb/symbols/ansi_hybrid
  sudo ln -sf $dfdir/assets/nvim-terminal.desktop /usr/share/applications/nvim-terminal.desktop
  sudo ln -sf $dfdir/assets/nnn-terminal.desktop /usr/share/applications/nnn-terminal.desktop
  echo "setxkbmap -layout ansi_hybrid -variant 5layer; exec spectrwm" >> $HOME/.xprofile
}

execute

