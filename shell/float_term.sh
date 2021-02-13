#!/usr/bin/env bash

identifier=kitty-float
active=$(xdotool getactivewindow)
kitty_float=$(xdotool search --class $identifier)

if [ -z $kitty_float ]; then
  kitty --class $identifier \
    -o background_opacity=0.9 \
    -o initial_window_width=1500 \
    -o initial_window_height=800 \
    -e bash -ic "tx $identifier"
elif [ $active == $kitty_float ]; then
  wmctrl -ir $active -b toggle,hidden
else
  echo $kitty_float | xargs wmctrl -iR
fi

