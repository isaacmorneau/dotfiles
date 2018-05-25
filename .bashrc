#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

alias grep='grep --color=auto'
alias ls='exa --group-directories-first'
alias ll='exa -l --group-directories-first'
alias sume='sudo -E'
alias fucking='sudo'
alias 'cd..'='cd ..'
alias bk='cd -'
alias gitwhat='git log -p -M --follow --stat --'


if [[ $EUID -eq 0 ]]; then
    export PATH="$PATH:~/.local/bin:~/.cargo/bin"
else
    #if youre not root as a fall back check current dir for command
    export PATH="$PATH:~/.local/bin:~/.cargo/bin:."
fi
export EDITOR='nvim'

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
#ps1_proc_result () {
#    [[ $1 -ne 0 ]] && printf "\033[43;33m \033[43;31m$1"
#}

# restriction being needs git 1.6.3 or newer
__git_ps1 () {
    git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '-'
}

#PROMPT_COMMAND='ps1_ret=$?'
PS1="\[\e[34m\]\D{%T}\[\e[35m\](\`__git_ps1\`)\[\e[36m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:\[\e[33m\]\W\[\e[m\]\$ "

export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
#this is to get around the fact that no one knows what termite is so ssh'ing is a pain
[[ $TERM != 'screen-256color' ]] && export TERM=xterm-256color

[ -f /usr/bin/clang ] && export CC=/usr/bin/clang
[ -f /usr/bin/clang++ ] && export CXX=/usr/bin/clang++

#fuck that stupid Ctl-s bullshit
stty -ixon

#if we ran wall lets get dem colors
#(wal -r -t &)
#wal is too much im disabling it

function google () {
    u=`perl -MURI::Escape -wle 'print "http://google.com/search?q=".uri_escape(join " ", @ARGV)' $@`
    w3m -no-mouse -F $u
}

function calc () {
    perl -ple '$_=eval'
}

function bri () {
    echo $1 > /sys/class/backlight/amdgpu_bl0/brightness
}

function cpi () {
    xclip -selection clipboard -t image/png -i $1
}

function lastscratch () {
    if [[ "$1" == "" ]]; then
        lastscratch=`find $HOME/.vimscratch/ -type f | sort | tail -n 1`
    else
        lastscratch=`find $HOME/.vimscratch/ -type f | sort | tail -n $1 | head -n 1`
    fi
    cat $lastscratch
}

function rain () {
    curl -s https://isitraining.in/vancouver | grep -oP '(?<=>)Yes|No(?=<)'
}

function slackfmt () {
    sed -E 's/^/    /' | sed -E 's/^([ ]{4,})(.+)([0-9]{2}:[0-9]{2})/\2/' | sed -E 's/[ ]{4,}[0-9]{2}:[0-9]{2}//' | sed -E 's/^[ ]{5,}/    /' | grep .
}

function reloadterm () {
    killall -USR1 termite
}

function weather () {
    curl wttr.in
}

