export PATH="$PATH:~/.local/bin"
xrdb -merge ~/.Xresources
DISPLAY=:0.1 exec i3 &
DISPLAY=:0.0 exec i3

