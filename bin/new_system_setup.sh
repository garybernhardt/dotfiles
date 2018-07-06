#!/usr/bin/env bash

set -e
brew install reattach-to-user-namespace --with-wrap-pbcopy-and-pbpaste

brew install git zsh vim ruby-install tmux wget fswatch ag postgresql lame python3 pngquant phantomjs heroku ghc multimarkdown graphviz offlineimap tree lua colordiff hub chruby jpeg selecta par2
brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb
brew install imagemagick --with-ghostscript
brew install ffmpeg --with-fdk-aac --with-x265

ruby-install ruby 2.4.2
