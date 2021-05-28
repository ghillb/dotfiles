#!/usr/bin/env bash

identifier=kitty-float
active=$(xdotool getactivewindow)
kitty_float=$(xdotool search --class $identifier)
if [ $# -gt 0 ]; then kitty_args="$@"; else "bash"; fi

if [ -z $kitty_float ]; then
  kitty --class $identifier \
    -o background_opacity=0.95 \
    -o initial_window_width=1500 \
    -o initial_window_height=800 \
    -o font_size=12.0 \
    -e $kitty_args
elif [ $active == $kitty_float ]; then
  wmctrl -ir $active -b toggle,hidden
else
  echo $kitty_float | xargs wmctrl -iR
fi

