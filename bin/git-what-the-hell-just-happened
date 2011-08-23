#!/bin/bash
set -e

ref=${1:-"HEAD"}

old=$ref@{1}
new=$ref

log() {
    git log --graph --pretty=short -1 $1
}

echo "Old revision:"
log $old
echo
echo "New revision:"
log $new
echo
echo "Changes:"
git diff --stat --summary $new $old

