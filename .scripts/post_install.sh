#!/usr/bin/env bash
set -eu

mkdir -p "$HOME/code"

# integrate fzf & bash config
~/.fzf/install --all
echo -e "source '$DOTFILES/.bash/bashrc'\n" >>$HOME/.bashrc


# add completion
mkdir ~/.bash_completion.d -p
curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias \
  >~/.bash_completion.d/complete_alias

# configure git
sudo git config --system pull.ff only
sudo git config --system credential.helper 'cache --timeout=43200'
