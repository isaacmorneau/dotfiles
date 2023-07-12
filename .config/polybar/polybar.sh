#!/usr/bin/env sh
# Terminate already running bar instances
killall -q polybar
# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

#setup envritonment
export ETH=$(ip link | awk '{print $2}' | grep -Eo '^en[a-z0-9]*')
export WIRE=$(ip link | awk '{print $2}' | grep -Eo '^wl[a-z0-9]*')

# Launch polybar
polybar --list-monitors | while read -r m
do
    MONITOR=$(cut -d":" -f1 <<< "$m") polybar $(grep -o 'primary' <<< "$m" || echo 'secondary') --reload -c ~/.config/polybar/config &
done
