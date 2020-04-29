#!/usr/bin/env bash

set -e
brew install reattach-to-user-namespace

brew install git zsh vim ruby-install tmux wget fswatch ag postgresql lame python3 pngquant ghc multimarkdown graphviz offlineimap tree lua colordiff hub chruby jpeg selecta par2 tokei diff-so-fancy dust tig fd nvm
brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb
brew install imagemagick
brew install ffmpeg
brew tap heroku/brew && brew install heroku

# Don't animate windows opening. This is different from applications opening.
# This applies when, for example, you have a running instance of Chrome or
# TextEdit and hit Cmd-N.
#
# Last verified working: 2020-04-27
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO
