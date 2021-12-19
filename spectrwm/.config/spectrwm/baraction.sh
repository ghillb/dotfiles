#!/bin/bash
# baraction.sh for spectrwm status bar

dte() {
  dte="$(date +"%d-%m-%Y, %H:%M")"
  echo -e "$dte"
}

hdd() {
  hdd="$(df -h | awk 'NR==3{print $5}')"
  echo -e "HDD: $hdd"
}

mem() {
  mem=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | xargs printf "%.0f")
  echo -e "RAM: $mem%"
}

cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e "CPU: $cpu%"
}

bat() {
  bat="$(cat /sys/class/power_supply/BAT0/capacity)"
  echo -e "ACC: $bat%"
}

## VOLUME only working on systems with amixer, add to loop < +@fg=4; +@fn=1;🔈+@fn=0; $(vol) +@fg=0; |">
# vol() {
#     vol=`amixer get Master | awk -F'[][]' 'END{ print $4":"$2 }'`
#     echo -e "VOL: $vol"
# }

SLEEP_SEC=5
while :; do
  echo " $(cpu) | $(mem) | $(hdd) | $(bat) | $(dte)"
	sleep $SLEEP_SEC
done

