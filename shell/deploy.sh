#!/usr/bin/env bash
set -euxo pipefail

dfdir=$HOME/.files
confdir=$HOME/.config

declare -a configs=( "df" "nvim" "tmux" "fzf" "utils" "desktop" )
declare -A deploy

sudo apt-get update && sudo apt-get upgrade -y;
sudo apt-get install -y build-essential git curl wget inetutils-ping

if $noninteractive == true ;then
  deploy["utils"]="y"
  deploy["nvim"]="y"
  deploy["tmux"]="y"
  deploy["fzf"]="y"
  deploy["df"]="y"
  deploy["desktop"]="n"
else
  for c in "${configs[@]}"; do echo "add [$c] config? (y / → n)"; read -s ans; deploy[$c]=$ans; done
  git clone https://github.com/ghillb/dotfiles.git $dfdir
fi

execute() {
  if [[ ${deploy["utils"]} == "y" ]]; then utils; fi
  if [[ ${deploy["nvim"]} == "y" ]]; then nvim; fi
  if [[ ${deploy["tmux"]} == "y" ]]; then tmux; fi
  if [[ ${deploy["fzf"]} == "y" ]]; then fzf; fi
  if [[ ${deploy["df"]} == "y" ]]; then df; fi
  if [[ ${deploy["desktop"]} == "y" ]]; then desktop; fi
  put_settings
}

df() {
  echo -e "source '$dfdir/configs/bashrc'\n" >> $HOME/.bashrc
  ln -sf $dfdir/assets/dircolors $HOME/.dircolors
  ln -sf $dfdir/assets/inputrc $HOME/.inputrc
  mkdir -p $HOME/code
}

nvim() {
  release=nvim-linux64
  mkdir -p ~/.config/nvim; ln -sf $dfdir/vim/init.vim $confdir/nvim/
  wget -nc https://github.com/neovim/neovim/releases/download/v0.5.1/${release}.tar.gz -O - > ${release}
  sudo tar -xf ${release} -C /tmp
  sudo cp -r /tmp/${release}/* /usr/local
  sudo rm -rf ${release} /tmp/${release}
  $(which nvim) --headless -u .files/vim/plugins.lua -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
  $(which nvim) --headless +"TSInstallSync all" +"q"
}

tmux() {
  sudo apt install -y tmux
  ln -sf $dfdir/configs/tmux.conf $HOME/.tmux.conf
}

fzf() {
  if ! command -v ag &> /dev/null; then sudo apt install -y silversearcher-ag; fi
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf; $HOME/.fzf/install --all
}

utils() {
  sudo apt install -y ripgrep sshfs nnn jq gron curl shellcheck ncdu direnv gcc make perl python3-venv python3-pip sqlite3 libsqlite3-dev
}

desktop() {
  sudo apt install -y spectrwm fonts-firacode ttf-ancient-fonts picom feh xdotool wmctrl xsel rofi kitty nnn zathura scrot
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

put_settings() {
  sudo git config --system pull.ff only
  sudo git config --system credential.helper 'cache --timeout=43200'
}

execute

