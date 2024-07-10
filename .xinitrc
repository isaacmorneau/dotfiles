export PATH="$PATH:~/.local/bin"
xrdb -merge ~/.Xresources
#for when running 2 x screens
#DISPLAY=:0.1 exec i3 &
#sleep 1 && DISPLAY=:0.0 exec i3

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xset s off
x -dpms
xset s noblank
exec i3
