#!/usr/bin/env bash
set -eu

dotfiles=$HOME/.files
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y git make
git clone https://github.com/ghillb/dotfiles.git $dotfiles
cd $dotfiles && make

