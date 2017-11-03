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
alias bk='cd -'


ps1_proc_result () {
    [[ $1 -ne 0 ]] && printf "|\033[31m$1"
}

ps1_branch_result () {
    git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '-'
}

PROMPT_COMMAND='ps1_ret=$?'
# restriction being needs git 1.6.3 or newer
PS1="\[\033[34m\]\D{%T}\[\033[m\]{\[\033[35m\]\`ps1_branch_result\`\[\033[m\]}\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h\[\033[m\]:\[\033[33;1m\]\W\[\033[m\]\`ps1_proc_result \$ps1_ret\`\[\033[m\] "

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
#this is to get around the fact that no one knows what termite is so ssh'ing is a pain
export TERM=xterm-256color

#fuck that stupid Ctl-s bullshit
stty -ixon
