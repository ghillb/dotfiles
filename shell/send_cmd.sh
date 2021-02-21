#!/bin/sh

send_cmd() {
	case $1 in
	win_del)
    wmctrl -c :ACTIVE:
		;;
	tab_del)
    xdotool windowactivate --sync $(xdotool getactivewindow) key Ctrl+F4
		;;
	*)
		;;
	esac;

}

send_cmd $1

