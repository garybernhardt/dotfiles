#!/bin/bash
 
# Plant rope vim's plugin
# This is a script to install or update 'ropevim'
# Copyright Alexander Artemenko, 2008
# Contact me at svetlyak.40wt at gmail com
 
function create_dirs
{
    mkdir -p src
    mkdir -p pylibs
}
 
function check_vim
{
    if vim --version | grep '\-python' > /dev/null
    then
echo You vim does not support python plugins.
        echo Please, install vim with python support.
        echo On debian or ubuntu you can do this:
        echo " sudo apt-get install vim-python"
        exit 1
    fi
}
 
function get_or_update
{
    if [ -e $1 ]
    then
cd $1
        echo Pulling updates from $2
        hg pull > /dev/null
        cd ..
    else
echo Cloning $2
        hg clone $2 $1 > /dev/null
    fi
}
 
function pull_sources
{
    cd src
    get_or_update rope http://bitbucket.org/agr/rope
    get_or_update ropevim http://bitbucket.org/agr/ropevim
    get_or_update ropemode http://bitbucket.org/agr/ropemode
 
    cd ../pylibs
    ln -f -s ../src/rope/rope
    ln -f -s ../src/ropemode/ropemode
    ln -f -s ../src/ropevim/ropevim.py
    cd ..
}
 
function gen_vim_config
{
    echo "let \$PYTHONPATH .= \":`pwd`/pylibs\"" > rope.vim
    echo "source `pwd`/src/ropevim/ropevim.vim" >> rope.vim
    echo "Now, just add \"source `pwd`/rope.vim\" to your .vimrc"
}
 
#check_vim
create_dirs
pull_sources
gen_vim_config
