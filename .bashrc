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

# restriction being needs git 1.6.3 or newer
PS1="\[\033[34m\]\D{%T}\[\033[m\]«\[\033[35m\]\$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '☼')\[\033[m\]»\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h\[\033[m\]:\[\033[33;1m\]\W\[\033[m\]\$ "

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
#this is to get around the fact that no one knows what termite is so ssh'ing is a pain
export TERM=xterm-256color

#fuck that stupid Ctl-s bullshit
stty -ixon
