#!/bin/bash
# 'dirs_to_search' - local directories to parse
dirs_to_search=$(cat $HOME/.config/local/index)
file="$(find $dirs_to_search -mindepth 0 -not -path '*/\.git/*' |\
  rofi -dmenu -i -P "open" -width 70)"
if [[ $file != "" ]]; then detach xdg-open "$file"; fi
exit 0

