export PATH=${PATH}:/usr/local/bin

# Add postgres to the path
export PATH=$PATH:/usr/local/pgsql/bin
export PATH=$PATH:/Library/PostgreSQL/8.3/bin

# Setting PATH for MacPython 2.5
# The orginal version is saved in .profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/Current/bin:${PATH}"
export PATH

alias xterm='xterm -bg black -fg lightgray -fa monaco -fs 14 -geometry 157x42 -sl 1024'
export TERM='xterm-color'

alias ls='ls -G'
alias l='ls'
alias ll='ls -l'
export GREP_OPTIONS="--color"
alias vi='mvim --remote-tab'
alias x='xargs'
alias g='grep'
alias xg='xargs grep'

export PATH="~/bin:$PATH"

BLACK="\[\033[0;30m\]"
DGRAY="\[\033[1;30m\]"
BLUE="\[\033[0;34m\]"
LBLUE="\[\033[1;34m\]"
GREEN="\[\033[0;32m\]"
LGREEN="\[\033[1;32m\]"
CYAN="\[\033[0;36m\]"
LCYAN="\[\033[1;36m\]"
RED="\[\033[0;31m\]"
LRED="\[\033[1;31m\]"
PURPLE="\[\033[0;35m\]"
LPURPLE="\[\033[1;35m\]"
BROWN="\[\033[0;33m\]"
YELLOW="\[\033[1;33m\]"
LGRAY="\[\033[0;37m\]"
WHITE="\[\033[1;37m\]"
NONE="\[\e[0m\]"

#LINES=`expr ${COLUMNS} - 1`
#BAR=""
#for ((i=0;i<=${LINES};i+=1)); do
    #BAR="${BAR}-"
#done
BAR="-------------------------------------------------------------------------------"
BAR="${DGRAY}${BAR}${NONE}\n"
# TEMP
BAR=""
#export PROMPT="(\u@\h) ${YELLOW}\W${NONE} # "
#export PS1="${BAR}${PROMPT}"

# Erase duplicates in history
export HISTCONTROL=erasedups
# Store 10k history entries
export HISTSIZE=10000
# Append to the history file when exiting, instead of overwriting it
shopt -s histappend

