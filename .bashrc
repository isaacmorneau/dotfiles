#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

alias grep='grep --color=auto'
alias ls='exa --group-directories-first'
alias ll='exa -l --group-directories-first'
alias tree='tree -C'
#ive done this too many times
alias ':q'='exit'

alias sume='sudo -E'
alias fucking='sudo'
#:yeet:
alias yeet='sudo'
alias yoot='sudo -E'

alias 'cd..'='cd ..'
alias bk='cd -'

alias gitwhat='git log -p -M --follow --stat --'

alias fpsteam='flatpak run com.valvesoftware.Steam'

alias cmaker='cmake -DCMAKE_BUILD_TYPE=Release ..'
alias cmaked='cmake -DCMAKE_BUILD_TYPE=Debug ..'

alias connected_mon='xrandr --query | grep " connected" | awk "{print \$1}"'

alias bn='LD_PRELOAD=libcurl.so.3 ~/binaryninja/binaryninja'

alias mpvf='mpv "$(fzf)"'

#kill bg tasks ignoring sigterm
alias kbg='kil -9 "$(jobs -p)"'

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

export LANG=en_US.UTF-8
#this is to get around the fact that no one knows what termite is so ssh'ing is a pain
[[ $TERM != 'screen-256color' ]] && export TERM=xterm-256color

#[ -f /usr/bin/clang ] && export CC=/usr/bin/clang
#[ -f /usr/bin/clang++ ] && export CXX=/usr/bin/clang++

hash backup_tend 2>/dev/null && alias shutdown="backup_tend && shutdown"

#fuck that stupid Ctl-s bullshit
stty -ixon

#auto cd
shopt -s autocd
# **/* recurse
shopt -s globstar

#if we ran wall lets get dem colors
#(wal -r -t &)
#wal is too much im disabling it

#fzf is really rad everywhere may as well use rg here too
FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'

# ==> STOLEN FROM STACK OVERFLOW <==
# https://stackoverflow.com/a/19533853/5539918
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

#cp image to clipboard
function cpi () {
    xclip -selection clipboard -t image/png -i $1
}

#get the last scratch file or nth to the end from the vim scratch system
#f can be added to get the path
function lastscratch () {
    if [[ "$1" == "" || "$1" == "f" ]]; then
        lastscratch=`find $HOME/.vimscratch/ -type f | sort | tail -n 1`
    else
        lastscratch=`find $HOME/.vimscratch/ -type f | sort | tail -n $1 | head -n 1`
    fi
    if [[ "$2" == "" && "$1" != "f" ]]; then
        cat $lastscratch
    else
        echo $lastscratch
    fi
}

#is it raining
function rain () {
    curl -s https://isitraining.in/vancouver | grep -oP '(?<=>)Yes|No(?=<)'
}

#slack formatting is dumb, this makes it less dumb
function slackfmt () {
    sed -r 's/^/    /;s/^([ ]{4,})(.+)([0-9]{2}:[0-9]{2})/\2/;s/[ ]{4,}[0-9]{2}:[0-9]{2}//;s/^[ ]{5,}/    /;' | grep .
}

#new changes reload
function reloadterm () {
    killall -USR1 termite
}

#what the weather currently is
function weather () {
    curl wttr.in
}

#find leetspeekable names from text data
function leetify () {
    grep -oP '^([0-9a-fots]|(?<!i)l|(?<!l)i){4,7}$' | sort -R | head -n 25 | tee ~/tmp | tr 'aeolits' '4301175' | tr a-z A-Z > ~/tmp2 && paste -d"\t" ~/tmp ~/tmp2 && rm ~/tmp ~/tmp2
}

#change filenames to be only sane characters
function mvsane () {
    for F in "$@"
    do
        FP=$(realpath -- "$F")
        BN=$(basename -- "$FP")
        BP=$(dirname -- "$FP")
        NN="${BP}/$(sed -r 's/[ ]+/_/g;s/[^a-zA-Z0-9_.-]//g;s/[_-]{2,}/-/g;s/(^[ _-]+|[ _-]+$)//g' <<< \"${BN}\")"
        [ "$FP" != "$NN" ] && mv -T -- "$FP" "$NN"
    done
}

#change access permissions to be only sane permissions
function chmodsane () {
    find "$1" -type d -exec chmod 755 {} \;
    find "$1" -type f -exec chmod 644 {} \;
}

#change access permissions to be only sane permissions
function chgrpsane () {
    chgrp -R "$1" "$2"
    find "$2" -type d -exec chmod 775 {} \;
    find "$2" -type f -exec chmod 664 {} \;
}


#thanks to john saying this:
#   [15:51] john_a_macdonald: Oh fuck off
#       The only worse option is mixing the digits
#       I prefer listing dates as YDYY-MD-MY
#i made it a thing
function bestdate () {
    date '+%Y-%m-%d' | sed -r 's/([0-9])([0-9])([0-9])([0-9])-([0-9])([0-9])-([0-9])([0-9])/\1\7\3\4-\5\8-\6\2/'
}

#test truecolor support (youll know if it doesnt work)
function truecolortest () {
    awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
            printf "\033[48;2;%d;%d;%dm", r,g,b;
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
            printf "%s\033[0m", substr(s,colnum+1,1);
        }
        printf "\n";
    }'
}

#thanks to this https://gist.github.com/timperez/7892680 im adding whoisport
function whoisport () {
    port=$1
    pidInfo=$(fuser $port/tcp 2> /dev/null)
    pid=$(echo $pidInfo | cut -d':' -f2)
    ls -l /proc/$pid/exe
}

#useful for debugging with binding with strace or whatever to a running process
#starts a process stopped
function startstopped () {
    ( kill -SIGSTOP $BASHPID; exec $@ ) &
}
#lets it continue
function resumestopped () {
    kill -SIGCONT $(jobs -l | grep '( kill -SIGSTOP $BASHPID; exec $@ )' | awk '{print $2}')
}

#convert files to shellcode escaped strings
function shellencode () {
    for F in "$@"
    do
        printf '"' && xxd -g 0 "$F" | awk '{print $2}' | fold -w2 | awk '{print "\\x" $1}' | tr -d '\n' && echo '"'
    done
}

#do it a bunch
function repeat () {
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do
        eval "$@";
    done
}

#gets random hex data by number of lines and number per line
function hexlines () {
    lin=$1
    wid=$2
    if [ $(($wid%2)) -eq 0 ]; then
        head -c $(($lin * $wid / 2)) /dev/urandom | xxd -g0 -| awk '{print $2}' | tr -d '\n' | fold -w$wid && echo
    else
        head -c $(($lin * $(($wid / 2 + 1)))) /dev/urandom | xxd -g0 -| awk '{print $2}' | tr -d '\n' | fold -w$wid | head -n $lin
    fi
}

#for testing ricing colors
alias colortest="echo use bettercolor instead"

#check ~/.local/bin/crazy.c for the version now in use
#function cRaZy () {
#    fold -w1 | awk 'NR % 2 == 1 {print toupper($0)}; NR % 2 == 0 {print tolower($0)}' | tr -d '\n'
#}

function localscan () {
    arp-scan --interface=$(ip link | grep 2 | awk '{print $2}' | tr -d ':') -l
}

function fine () {
    sed -r 's/(.)/\1 /g;s/(.*) /`\1`/g;'
}

function sofine () {
    sed -r 's/(.)/\1 /g;s/(.*) /_\*\*`\1`\*\*_/g;'
}

#honestly why is this not built in...
#sum ints one per line
#check ~/.local/bin/total.c for the version now in use
#function total () {
#    awk '{s+=$1} END {print s}'
#}

#this automatically generates index.html files for the entire current directory
#note the grep for exclusion is because the built in affects the output
#also yes im fixing the CSS colors with sed, if you can get LS_COLORS to work you better open a PR
function mkhtmltree () {
    find . -type d -exec bash -c "cd {}; tree --dirsfirst --du --prune -DhHC . | grep -v 'index.html' | sed -r '0,/(\.NORM.*)black/{s/(\.NORM.*)black/\1blue/};0,/(\.DIR.*)blue/{s/(\.DIR.*)blue/\1black/};s/\"([^\"]*\.(png|jpg))\">([^<]*)/\"\1\"><img src=\"\1\" height=\"200\">/g' > index.html" \;
}

#generate documentation comments for c
function mkcdoc () {
    for F in "$@"
    do
        sed -rf ~/.local/sed/mkcdoc.sed -i $F
    done
}
#generate documentation comments for asm
function mksmdoc () {
    for F in "$@"
    do
        sed -rf ~/.local/sed/mkasmdoc.sed -i $F
    done
}

function sedcheat () {
    echo '==>sed quick guide<==
:  # label
=  # line_number
a  # append_text_to_stdout_after_flush
b  # branch_unconditional
c  # range_change
d  # pattern_delete_top/cycle
D  # pattern_ltrunc(line+nl)_top/cycle
g  # pattern=hold
G  # pattern+=nl+hold
h  # hold=pattern
H  # hold+=nl+pattern
i  # insert_text_to_stdout_now
l  # pattern_list
n  # pattern_flush=nextline_continue
N  # pattern+=nl+nextline
p  # pattern_print
P  # pattern_first_line_print
q  # flush_quit
r  # append_file_to_stdout_after_flush
s  # substitute
t  # branch_on_substitute
w  # append_pattern_to_file_now
x  # swap_pattern_and_hold
y  # transform_chars '
}

#sometimes you need to diff binary files, this makes it easy
function bdiff () {
    if [ $# -ne 2 ]
    then
        echo "usage: bdiff file1 file2"
    else
        diff --color=auto -c --label "$1" --label "$2" <(xxd "$1") <(xxd "$2")
    fi
}

#dont ask me why i needed this, but it gets all the links in a page seperated by newlines
function linkrip () {
    sed -r 's/(href=")([^"]*)"/\n"\2"\n/' | grep -Po '^".*"$' | tr -d '"'
}

#all my v4 ips on all up interfaces
function allv4 () {
    ip addr show up | grep -v 'lo$' | grep 'inet ' | awk '{print $2}'
}

function batstat () {
    for B in /sys/class/power_supply/BAT*
    do
        if [ -f "$B/capacity" ]; then
            echo "[$B]"
            printf "capacity: "
            cat "$B/capacity"
            printf "status: "
            cat "$B/status"
        fi
    done
}

# :3
function exit () {
    eval $BASH_COMMAND
}

# select a saved session and open it
function nvimp() {
    VCMD=$(command -v nvim &>/dev/null && echo nvim || echo vim)
    if [ $VCMD == "nvim" ]; then
        VFL="$HOME/.local/share/nvim/session"
    else
        VFL="$HOME/.vim/session"
    fi
    FILE=$(find $VFL -type f | fzf +m -1)
    if [ -n "$FILE" ]; then
        VCD=$(grep -Em 1 'cd ' "$FILE")
        if [ -n "$VCD" ]; then
            ${VCD//\~/$HOME}
        fi
        $VCMD
    fi
}

#sometimes you just need to reload it all
function usb_knockknock() {
    sudo udevadm control --reload-rules
    sudo udevadm trigger -v
}

#for when you dont want any [redacted]
function redact_anime() {
    sed -r 's/[aA]+(.*)?[nN]+([^a-zA-Z]+|\1)?[1liI]+([^a-zA-Z]+|\1)?[mM]+([^a-zA-Z]+|\1)?[eEuU3]+/[redacted]/ig'
}

#the above spawned the following
#this generates out a regex like above from a given word
function censor_regex() {
    sed -r 's/([a-z])/[\1]+(.*)?/;:a;/[^a-z][a-z]$/{s/(.*)([a-z])$/\1[\2]+/;q};s/(^.*[^a-z])([a-z])/\1[\2]+([^a-z]+|\\1)?/g;ta'
}

#i cant stand /**/ comments, this converts them to // style as best as it can
function fix_comments() {
    sed -r ':s;/\/\*/{:g;N;/\*\//{s/(.*)/\/\/\1/g;s/(\/\*|\*\/)//g;s/\n\s*\*/\n/g;s/\n/\n\/\//g;s/(^|\n)\s+\n//g;s/^[\s\/\n]*(\/\/)/\1/g;bs};bg}'
}

#in place removal of anything nonprintable inspired by https://xkcd.com/2143/
function asciionly() {
    tmp=$(tr -d "\0" < "$1")
    cat <<< "${tmp//[^ -~]}" > "$1"
}

alias clap="sed -r 's/\\s+/ :clap: /g'"

#extract an sql connection string for use manually
function mysqlconf() {
    sed -r 's#^.*mysql://([^:]+):([^@]+)\@([^/]+)/([^"]+)".*$#mysql -u\1 -p\2 -h\3 \4#g;tg;d;:g;' | sort | uniq
}

#god forbid you ever need this but it turns numbers into their ordinal counterparts ie 1st, 2nd, 3rd, 11th, 21st,...
function ordinal() {
    sed -r 's/(^|[^0-9]|[02-9])1( |$)/\11st\2/g;s/(^|[^0-9]|[02-9])2( |$)/\12nd\2/g;s/(^|[^0-9]|[02-9])3( |$)/\13rd\2/g;s/(^|[^0-9]|[0-9])?([0-9])( |$)/\1\2th\3/g'
}

function mvmanual () {
    for F in "$@"
    do
        FP=$(realpath -- "$F")
        BN=$(basename -- "$FP")
        BP=$(dirname -- "$FP")
        TMP_FILE=$(mktemp)
        cat -- > "${TMP_FILE}" <<< "${BN}"
        nvim "${TMP_FILE}"
        NN=$(<"${TMP_FILE}")
        rm "${TMP_FILE}"
        NP="${BP}/$NN"
        [ "$FP" != "$NP" ] && mv -T -- "$FP" "$NP"
    done
}

#moved this to the bottom because it breaks syntax highlighting bad
__last_cmd="[ \$? == 0 ]&&printf '\[\e[32m\]^_^'||printf '\[\e[31m\]ಠ_ಠ'"
# restriction being needs git 1.6.3 or newer
__git_ps1='git rev-parse --abbrev-ref HEAD 2>/dev/null||printf "-"'
#this is so that the working dir goes red if the fs doesnt match the root as an indicator of risk otherwise its yellow
__same_fs="[ \"$(df --output=source /)\" == \"\$(df --output=source .)\" ]&&printf '\[\e[33m\]'||printf '\[\e[31m\]'"

PS1="\e[m\]\e[37m\]┍\$(${__last_cmd})\[\e[34m\]\D{%T}\[\e[35m\]\$(${__git_ps1})\[\e[36m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:\$(${__same_fs})\W\n\[\e[37m\]┕\[\e[m\]> "
