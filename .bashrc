#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

alias grep='grep --color=auto'
alias ls='exa'
alias sume='sudo -E'
alias fucking='sudo'
alias 'cd..'='cd ..'
alias bk='cd -'


#ps1_proc_result () {
#    [[ $1 -ne 0 ]] && printf "\033[43;33m \033[43;31m$1"
#}

# restriction being needs git 1.6.3 or newer
#ps1_branch_result () {
#    git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '-'
#}

#PROMPT_COMMAND='ps1_ret=$?'
PS1="\[\033[44;30m\]\D{%T}\[\033[46;34m\]\[\033[46;30m\]\u\[\033[42;36m\]\[\033[42;30m\]\h\[\033[43;32m\]\[\033[43;30m\]\W\[\033[49;33m\]\[\033[m\] "

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
#this is to get around the fact that no one knows what termite is so ssh'ing is a pain
export TERM=xterm-256color

#fuck that stupid Ctl-s bullshit
stty -ixon

#if we ran wall lets get dem colors
#(wal -r -t &)
#wal is too much im disabling it
