#!/bin/bash

set -e

(
    function branch() {
        git branch 2>/dev/null | grep -e '^*' | tr -d '\* '
    }

    function ensure_valid_ref() {
        ref=$1
        (
            set +e
            git show-ref $ref > /dev/null
            if [[ $? == 1 ]]; then
                echo "$0: bad ref: $ref"
                exit 1
            fi
        )
    }

    function show_rev() {
        rev=$1
        git log -1 $rev --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
        echo
        git di $rev^..$rev | diffstat
        echo
    }

    if [[ $# == 2 ]]; then
        LOCAL=$1
        REMOTE=$2
    elif [[ $# == 1 ]]; then
        LOCAL=`branch`
        REMOTE=$1
    else
        LOCAL=`branch`
        REMOTE=origin/$LOCAL
    fi

    ensure_valid_ref $LOCAL
    ensure_valid_ref $REMOTE

    echo "changes from local ${LOCAL} to remote ${REMOTE}:"
    echo

    echo incoming:
    echo
    for rev in `git rev-list $LOCAL..$REMOTE`; do
        show_rev $rev
    done
    
    echo
    echo outgoing:
    echo
    for rev in `git rev-list $REMOTE..$LOCAL`; do
        show_rev $rev
    done
) | less -r

