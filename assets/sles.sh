#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/ghillb/dotfiles/master/assets/sles.sh)

dfdir=$HOME/.files

sudo zypper up;
sudo zypper addrepo https://download.opensuse.org/repositories/editors/SLE_15/editors.repo
sudo zypper addrepo https://download.opensuse.org/repositories/utilities/SLE_15_SP2/utilities.repo
sudo zypper refresh
sudo zypper remove vim
sudo zypper install -y vim tmux git
git clone https://github.com/ghillb/dotfiles.git $dfdir
ln -sf $dfdir/assets/dircolors ~/.dircolors
ln -sf $dfdir/assets/inputrc ~/.inputrc
ln -sf $dfdir/vimrc ~/.vimrc
ln -sf $dfdir/tmux.conf ~/.tmux.conf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install --all
echo -e "# my dotfile additions\n. '$dfdir/bashrc'\n" >> ~/.bashrc
echo -e "# additional completions\n. '$dfdir/assets/completion.sh'" >> ~/.bashrc

