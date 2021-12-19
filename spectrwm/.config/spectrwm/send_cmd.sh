#!/bin/sh

send_cmd() {
	case $1 in
	win_del)
    wmctrl -c :ACTIVE:
		;;
	tab_del)
    xdotool windowactivate --sync $(xdotool getactivewindow) key Ctrl+F4
		;;
	autotype_focus)
    xsel -o | tr \\n \\r | xdotool type --clearmodifiers --delay 25 --file -
		;;
	autotype_target)
    xsel -o | tr \\n \\r | xdotool selectwindow windowfocus type --clearmodifiers --delay 25 --window %@ --file -
		;;
	*)
		;;
	esac;

}

send_cmd $1

