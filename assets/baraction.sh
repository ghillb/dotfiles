#!/bin/bash
# baraction.sh for spectrwm status bar

## DATE
dte() {
  dte="$(date +"%A, %B %d %Y %H:%M")"
  echo -e "$dte"
}

## DISK
hdd() {
  hdd="$(df -h | awk 'NR==4{print $3, $5}')"
  echo -e "HDD: $hdd"
}

## RAM
mem() {
  mem=`free | awk '/Mem/ {printf "%dM/%dM\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo -e "$mem"
}

## CPU
cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e "CPU: $cpu%"
}

## VOLUME only working on systems with amixer, add to loop < +@fg=4; +@fn=1;🔈+@fn=0; $(vol) +@fg=0; |">
# vol() {
#     vol=`amixer get Master | awk -F'[][]' 'END{ print $4":"$2 }'`
#     echo -e "VOL: $vol"
# }

SLEEP_SEC=5
# outputting a line every SLEEP_SEC secs
while :; do
    echo " $(cpu) | $(mem) | $(hdd) | $(dte)"
	sleep $SLEEP_SEC
done
