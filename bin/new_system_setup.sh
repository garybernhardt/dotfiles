#!/usr/bin/env bash

set -e
brew install reattach-to-user-namespace --with-wrap-pbcopy-and-pbpaste

brew install git zsh vim ruby-install tmux wget fswatch ack postgresql lame python3 pngquant phantomjs heroku ghc multimarkdown graphviz offlineimap tree lua colordiff hub chruby gem_home jpeg
brew install imagemagick --with-ghostscript
brew install ffmpeg --with-fdk-aac --with-x265

ruby-install ruby 2.3.1
