#!/usr/bin/env bash
set -eu

# integrate fzf & bash config
~/.fzf/install --all
echo -e "source '$DOTFILES/.bash/bashrc'\n" >>$HOME/.bashrc

# install nvim plugins
mkdir -p "$HOME/code" # otherwise nvim complains
pip install --user neovim
$(which nvim) --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
$(which nvim) --headless +"TSInstallSync all" +"q"
$(which nvim) --headless +"LspInstall pylsp" +"q"

# add completion
mkdir ~/.bash_completion.d -p
curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias \
  >~/.bash_completion.d/complete_alias
# activate-global-python-argcomplete{,3} --dest ~/.bash_completion.d/

# configure git
sudo git config --system pull.ff only
sudo git config --system credential.helper 'cache --timeout=43200'
