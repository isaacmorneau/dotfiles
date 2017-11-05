#!/usr/bin/env sh
# Terminate already running bar instances
killall -q polybar
# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done
# Launch polybar
for i in $(polybar -m | awk -F: '{print $1}');
do
    export MONITOR=$i
    polybar main -c ~/.config/polybar/config &
done
