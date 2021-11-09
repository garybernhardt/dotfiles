#!/usr/bin/env bash

set -e -o pipefail
brew install reattach-to-user-namespace

# Install misc packages. These are broken into groups just because some of them
# sometimes fail, and this makes bisecting a bit easeier.
brew install git zsh vim ruby-install tmux wget fswatch ag postgresql lame
brew install python3 pngquant ghc multimarkdown graphviz offlineimap tree lua
brew install colordiff hub chruby jpeg selecta par2 tokei diff-so-fancy dust
brew install tig fd nvm htop coreutils pstree rsync n

brew install imagemagick

brew tap varenc/ffmpeg
brew install varenc/ffmpeg/ffmpeg --with-fdk-aac

brew tap heroku/brew
brew install heroku

pip3.9 install rotate-backups

# Don't animate windows opening. This is different from applications opening.
# This applies when, for example, you have a running instance of Chrome or
# TextEdit and hit Cmd-N.
#
# Last verified working: 2020-04-27
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO

# MANUAL STEPS:
# - Install gem_home from https://github.com/postmodern/gem_home
