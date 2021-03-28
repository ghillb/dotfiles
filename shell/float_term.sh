#!/usr/bin/env bash

identifier=kitty-float
active=$(xdotool getactivewindow)
kitty_float=$(xdotool search --class $identifier)

if [ -z $kitty_float ]; then
  kitty --class $identifier \
    -o background_opacity=0.95 \
    -o initial_window_width=1500 \
    -o initial_window_height=800 \
    -o font_size=14.0 \
    -e bash
elif [ $active == $kitty_float ]; then
  wmctrl -ir $active -b toggle,hidden
else
  echo $kitty_float | xargs wmctrl -iR
fi

