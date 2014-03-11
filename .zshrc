# Set custom prompt
setopt PROMPT_SUBST
autoload -U promptinit
promptinit
prompt grb

# Initialize completion
autoload -U compinit
compinit

# Add paths
export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
export PATH="$HOME/bin:$PATH"

# Colorize terminal
alias ls='ls -G'
alias ll='ls -lG'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

# Nicer history
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# Use vim as the editor
export EDITOR=vi
# GNU Screen sets -o vi if EDITOR=vi, so we have to force it back.
set -o emacs

# Use C-x C-e to edit the current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# By default, zsh considers many characters part of a word (e.g., _ and -).
# Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'

# Highlight search results in ack.
export ACK_COLOR_MATCH='red'

# Aliases
t() {
    if [ -e script/test ]; then
        script/test $*
    else
        rspec --color spec
    fi
}
alias f="script/features $*"
alias z="zeus $*"
alias r="script/rails $*"
function lack() {
    # The +k clears the screen (it tries to scroll up but there's nowhere to
    # go)
    ack --group --color $* | less -r +k
}
function mcd() { mkdir -p $1 && cd $1 }
function cdf() { cd *$1*/ } # stolen from @topfunky
function das() {
    cd ~/proj/destroyallsoftware.com/destroyallsoftware.com
    pwd
    . ~/Documents/filing/business/destroy\ all\ software\ llc/s3.sh
    . ~/Documents/filing/business/destroy\ all\ software\ llc/braintree.sh
    . ~/Documents/filing/business/destroy\ all\ software\ llc/cloudfront.sh
}
alias v="view -"
function m() {
    if [[ "$1" == "das" ]]; then
        mutt -F ~/.mutt/das.muttrc
    else
        ~/proj/thelongpoll/thelongpoll/thelongpoll client -F ~/.mutt/$1.muttrc
    fi
}
alias c="cd"

# Activate the closest virtualenv by looking in parent directories.
activate_virtualenv() {
    if [ -f env/bin/activate ]; then . env/bin/activate;
    elif [ -f ../env/bin/activate ]; then . ../env/bin/activate;
    elif [ -f ../../env/bin/activate ]; then . ../../env/bin/activate;
    elif [ -f ../../../env/bin/activate ]; then . ../../../env/bin/activate;
    fi
}

# Find the directory of the named Python module.
python_module_dir () {
    echo "$(python -c "import os.path as _, ${1}; \
        print _.dirname(_.realpath(${1}.__file__[:-1]))"
        )"
}

# By @ieure; copied from https://gist.github.com/1474072
#
# It finds a file, looking up through parent directories until it finds one.
# Use it like this:
#
#   $ ls .tmux.conf
#   ls: .tmux.conf: No such file or directory
#
#   $ ls `up .tmux.conf`
#   /Users/grb/.tmux.conf
#
#   $ cat `up .tmux.conf`
#   set -g default-terminal "screen-256color"
#
function up()
{
    local DIR=$PWD
    local TARGET=$1
    while [ ! -e $DIR/$TARGET -a $DIR != "/" ]; do
        DIR=$(dirname $DIR)
    done
    test $DIR != "/" && echo $DIR/$TARGET
}

# Switch projects
function p() {
    set -e
    proj=$(ls ~/proj | selecta)
    if [[ -n "$proj" ]]; then
        cd ~/proj/$proj
    fi
}

zstyle ':completion:*:*:git:*' script /usr/local/share/zsh/site-functions

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Initialize RVM
#PATH=$PATH:$HOME/.rvm/bin
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"

#source /usr/local/share/chruby/chruby.sh
#source /usr/local/share/chruby/auto.sh
