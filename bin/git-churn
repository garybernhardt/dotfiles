#!/bin/bash
#
# Written by Corey Haines
# Scriptified by Gary Bernhardt
#
# Put this anywhere on your $PATH (~/bin is recommended). Then git will see it
# and you'll be able to do `git churn`.
#
# Churn means "frequency of change". You'll get an output like this:
#
# $ git churn
#    1 file1
#   22 file2
#  333 file3
#
# This means that file1 changed one time, file2 changes 22 times, and file3
# changes 333 times.
#
# Show churn for whole repo:
#   $ git churn
#
# Show churn for specific directories:
#   $ git churn app lib
#
# Show churn for a time range:
#   $ git churn --since='1 month ago'
#
# (These are all standard arguments to `git log`.)

set -e
git log --all -M -C --name-only --format='format:' "$@" | sort | grep -v '^$' | uniq -c | sort -n
