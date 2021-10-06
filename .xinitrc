export PATH="$PATH:~/.local/bin"
xrdb -merge ~/.Xresources
#for when running 2 x screens
#DISPLAY=:0.1 exec i3 &
#sleep 1 && DISPLAY=:0.0 exec i3

exec i3
