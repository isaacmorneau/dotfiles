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
export NQBASE_BINFILES="/home/isaac/code/azorian/"
export NQBASE_DEV_PATH="/home/isaac/code/nqbase/"
export ANTHIVE_COMMAND="python3 '/home/isaac/code/anthive/hive.py'"
