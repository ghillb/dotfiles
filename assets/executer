#!/bin/bash

executable="$(echo | rofi -dmenu -P "run (bash)" -lines 0)"
if [[ $executable != "" ]]; then kitty bash -ic $executable; fi
exit 0

