#!/bin/sh

xsel -o | tr \\n \\r | xdotool type --clearmodifiers --delay 25 --file -
# xsel -o | tr \\n \\r | xdotool selectwindow windowfocus type --clearmodifiers --delay 25 --window %@ --file -

