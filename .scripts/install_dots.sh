#!/usr/bin/env bash
set -eu

PACKAGES=$(ls -d $DOTFILES/*/ | awk -F "/" '{ print $(NF-1) }')
SYSTEM_PACKAGES='xkb bin'

for P in $PACKAGES ; do
    if [[ " $SYSTEM_PACKAGES " =~ " $P " ]]; then
      TARGET=/
      PREFIX="sudo"
    else
      TARGET=$HOME
      PREFIX=""
    fi

    # remove old and install new links with stow
    $PREFIX stow --dotfiles --dir $DOTFILES --target $TARGET $P -D 2>/dev/null
    $PREFIX stow --dotfiles --dir $DOTFILES --target $TARGET $P

    echo "✓ install :: $P"
done
