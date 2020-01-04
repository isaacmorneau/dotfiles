#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [[ $EUID -eq 0 ]]; then
    export PATH="$PATH:~/.local/bin:~/.cargo/bin"
else
    #if youre not root as a fall back check current dir for command
    export PATH="$PATH:~/.local/bin:~/.cargo/bin:."
fi
export QT_QPA_PLATFORMTHEME="qt5ct"
