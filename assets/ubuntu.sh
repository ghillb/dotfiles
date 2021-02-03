#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/ghillb/dotfiles/master/assets/ubuntu.sh)

apt-get install -y vim neovim tmux
mkdir -p $HOME/.config/nvim
dfdir=$HOME/.files
ln -sf $dfdir/assets/dircolors ~/.dircolors
ln -sf $dfdir/assets/inputrc ~/.inputrc
ln -sf $dfdir/vimrc ~/.vimrc
ln -sf $dfdir/vimrc ~/.config/nvim/init.vim
ln -sf $dfdir/tmux.conf ~/.tmux.conf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install --all
echo -e "# my dotfile additions\n. '$dfdir/bashrc'\n" >> ~/.bashrc
echo -e "# additional completions\n. '$dfdir/assets/completion.sh'" >> ~/.bashrc

