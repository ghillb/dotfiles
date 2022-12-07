#!/usr/bin/env bash
set -eu

dotfiles=$HOME/.files

if [ -f /etc/redhat-release ]; then
  pkgman=dnf
fi

if [ -f /etc/lsb-release ]; then
  pkgman=apt-get
fi

sudo $pkgman -y update && sudo $pkgman upgrade -y && sudo $pkgman install -y \
    git \
    make \
    ansible

git clone https://github.com/ghillb/dotfiles.git $dotfiles
cd $dotfiles && make

