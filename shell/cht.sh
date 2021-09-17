#!/usr/bin/env bash
languages="pyton java nodejs cpp rust lua"
selected=$(echo -n $languages | tr ' ' '\n' | fzf)
read -p "Enter Query: " query

query=$(echo $query | tr ' ' '+')
echo "curl cht.sh/$selected/$query"
kitty @ launch --type=tab bash -c "curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"

