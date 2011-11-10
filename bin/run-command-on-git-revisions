#!/bin/bash
#
# This script runs a given command over a range of Git revisions. Note that it
# will check past revisions out! Exercise caution if there are important
# untracked files in your working tree.
#
# This came from Gary Bernhardt's dotfiles:
#     https://github.com/garybernhardt/dotfiles
#
# Example usage:
#     $ run-command-on-git-revisions origin/master master 'python runtests.py'

set -e

if [[ $1 == -v ]]; then
    verbose=1
    shift
fi
start_ref=$1
end_ref=$2
test_command=$3

main() {
    enforce_usage
    run_tests
}

enforce_usage() {
    if [ -z "$test_command" ]; then
        usage
        exit $E_BADARGS
    fi
}

usage() {
    echo "usage: `basename $0` start_ref end_ref test_command"
}

run_tests() {
    revs=`log_command git rev-list --reverse ${start_ref}..${end_ref}`

    for rev in $revs; do
        debug "Checking out: $(git log --oneline -1 $rev)"
        log_command git checkout --quiet $rev
        log_command $test_command
        log_command git reset --hard
    done
    log_command git checkout --quiet $end_ref
    debug "OK for all revisions!"
}

log_command() {
    debug "=> $*"
    eval $*
}

debug() {
    if [ $verbose ]; then
        echo $* >&2
    fi
}

main

