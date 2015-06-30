#!/usr/bin/python

#
# Print a diff summary like:
#
#   $ git diff 'master~10..master' | gn
#   293 lines of diff
#   185 lines added
#   19 lines removed
#   +166 lines net change

import sys, os, re, fileinput

def get_lines(diff_lines):
    # Added lines start with '+' (but not '+++', because that marks a new
    # file).  The same goes for removed lines, except '-' instead of '+'.
    added_lines = [line for line in diff_lines
        if line.startswith('+') and not line.startswith('+++')]
    removed_lines = [line for line in diff_lines
        if line.startswith('-') and not line.startswith('---')]
    return added_lines, removed_lines

def get_words(added_lines, removed_lines):
    def word_count(lines):
        return [word
                for line in lines
                for word in line.split()
                if re.match(r'^\w+', word)]

    return word_count(added_lines), word_count(removed_lines)

if __name__ == '__main__':
    diff_lines = list(fileinput.input())
    added_lines, removed_lines = get_lines(diff_lines)
    added_words, removed_words = get_words(added_lines, removed_lines)
    print '%i lines of diff' % len(diff_lines)
    print '%+i lines (+%i, -%i)' % (len(added_lines) - len(removed_lines),
                                    len(added_lines),
                                    len(removed_lines))
    print '%+i words (+%i, -%i)' % (len(added_words) - len(removed_words),
                                    len(added_words),
                                    len(removed_words))

