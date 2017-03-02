#!/bin/bash
#
# @author Hermann Mayer <hermann.mayer92@gmail.com>
# @name .bashrc

# +-------------------------------------------------
# | UTF8 Stuff
# +-------------------------------------------------

if test -t 1 -a -t 2 ; then
    echo -n -e '\033%G'
fi

# +-------------------------------------------------
# | Non-Interactive Shell
# +-------------------------------------------------

if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

# +-------------------------------------------------
# | Exports
# +-------------------------------------------------

# Misc defaults
export HISTCONTROL="ignoreboth:erasedups"
export HISTSIZE=1000000
export PROMPT_DIRTRIM=0
export USER_NAME=$(whoami)
export COLUMNS=$(tput cols)

# Enable less mouse scrolling
export LESS=-r

# Default Editor
export EDITOR=vim

# Color programs output
export COLOR_OPTIONS='--color=auto'

# Color 'man' output
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.svgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01; 35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:'

export LS_COLORS

# +-------------------------------------------------
# | Autoloading Stuff
# +-------------------------------------------------

# Really usefull, load bash auto completion
if [ -f /etc/profile.d/bash_completion.sh ]; then
    source /etc/profile.d/bash_completion.sh
fi
if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi
if [ -d "${BASHRC_CONFIG}/completions" ]; then
    for file in $(find "${BASHRC_CONFIG}/completions/" -type f) ; do
        source "${file}"
    done
fi

# +-------------------------------------------------
# | Terminal Settings
# +-------------------------------------------------

if [ "$TERM" != 'linux' ]; then
    # Set the default 256 color TERM
    export TERM=xterm-256color
fi

# +-------------------------------------------------
# | Bash Settings
# +-------------------------------------------------

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Enable extended globbing
shopt -s extglob

# Enable globbing for dotfiles
shopt -s dotglob

# Enable globstars for recursive globbing
shopt -s globstar

# Auto "cd" when entering just a path
shopt -s autocd

# +-------------------------------------------------
# | Binding Bash Events
# +-------------------------------------------------

# Rebind enter key to insert newline before command output
trap 'echo' DEBUG

# +-------------------------------------------------
# | Usefull Keybindings
# +-------------------------------------------------

bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
bind "set bell-style none"           # no bell
bind "set show-all-if-ambiguous On"  # show list automatically, without double tab

# use ctl keys to move forward and back in words
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'
bind '"\e[5C": forward-word'
bind '"\e[5D": backward-word'
bind '"\e\e[C": forward-word'
bind '"\e\e[D": backward-word'

# use arrow keys to fast search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# +-------------------------------------------------
# | Usefull Aliases
# +-------------------------------------------------

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias folders='find . -maxdepth 1 -type d -print0 | xargs -0 du -hs | sort -rn'
alias c='clear'
alias h='htop'
alias f='free -m'
alias ls='ls $COLOR_OPTIONS --group-directories-first --time-style="+%F, %T "'
alias ll='ls $COLOR_OPTIONS -lh'
alias la='ls $COLOR_OPTIONS -lAh'
alias l='ls $COLOR_OPTIONS -lAh'
alias grep='grep $COLOR_OPTIONS'
alias egrep='egrep $COLOR_OPTIONS'
alias g='git'
alias p='pwd'
alias mkdir='mkdir -p -v'
alias openports='netstat --all --numeric --programs --inet --inet6 | tail -n +3 | rev | sort -k 1,1 | rev'
alias less='less -R'
alias x='exit'

complete -W "$(cat "${HOME}/.bash_history" | egrep '^ssh |^scp ' | grep '\.' | egrep '^[^0-9]' | sort | uniq | sed 's/^ssh //' | sed 's/ $//g' | sed 's/^/\"/' | sed 's/$/\"/');" ssh
complete -W "$(cat "${HOME}/.bash_history" | egrep '^ssh |^scp ' | grep '\.' | egrep '^[^0-9]' | sort | uniq | sed 's/^ssh //' | sed 's/ $//g' | sed 's/^/\"/' | sed 's/$/\"/');" scp

# +-------------------------------------------------
# | Style Commandline Prompt
# +-------------------------------------------------

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
        && type -P dircolors >/dev/null \
        && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
        # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
        if type -P dircolors >/dev/null ; then
            if [[ -f ~/.dir_colors ]] ; then
                    eval $(dircolors -b ~/.dir_colors)
            elif [[ -f /etc/DIR_COLORS ]] ; then
                    eval $(dircolors -b /etc/DIR_COLORS)
            fi
        fi

        PROMPT_COMMAND='RET=$?;'
        RET_OUT='$(if [[ $RET = 0 ]]; then echo -ne "\[$txtgrn\][G]"; else echo -ne "\[$txtred\][Err: $RET]"; fi;)'
        RET_OUT="\n$RET_OUT"

        PSL1A=' \[\e[0;31m\][\[\e[1;37m\]\[\e[0;36m\]\w\[\e[0;31m\]]'
        PSL1=${RET_OUT}${PSL1A}
        PSL2='\n\[\e[0;31m\][\u\[\e[0;33m\]@\[\e[0;37m\]\h\[\e[0;31m\]] \[\e[0;31m\]$ \[\e[0;32m\]'

        PS1=${PSL1}${PSL2}
else
        if [[ ${EUID} == 0 ]] ; then
            # show root@ when we do not have colors
            PS1='\u@\h \W \$ '
        else
            PS1='\u@\h \w \$ '
        fi
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

# +-------------------------------------------------
# | Commons Helper
# +-------------------------------------------------

function psgrep()
{
    ps ax -o pid,ruser,command | egrep -i --color=always "$1" | grep -v "grep"
}

function mkcd()
{
    mkdir -p "$1"
    cd "$1"
}

# +-------------------------------------------------
# | Find Helper
# +-------------------------------------------------

# ff:  to find a file under the current directory
function ff()
{
    /usr/bin/find . -name '*'"$@"'*' | grep -i "$@"
}

# ffs: to find a file whose name starts with a given string
function ffs()
{
    /usr/bin/find . -name "$@"'*'
}

# ffe: to find a file whose name ends with a given string
function ffe()
{
    /usr/bin/find . -name '*'"$@"
}

function findPid()
{
    lsof -t -c "$@"
}

function findTopLevelParentPid()
{
    pid=${1:-$$}
    stat=($(</proc/${pid}/stat))
    ppid=${stat[3]}
    if [[ ${ppid} -eq 1 ]] ; then
        echo ${pid}
    else
        findTopLevelParentPid ${ppid}
    fi
}

function finder()
{
    if [ "${1}" = "-svn" ]; then
        shift
        find . -type f ! -path "*svn*" -exec grep -n -H --colour=auto -i "${@}" {} \;
        return
    fi

    find . -type f -exec grep -n -H --colour=auto -i "${@}" {} \;
}

clear

cd /share
