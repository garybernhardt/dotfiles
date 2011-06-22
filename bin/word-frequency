#!/usr/bin/env bash

ruby -F'[^a-zA-Z]+' -ane '
    BEGIN   { $words = Hash.new(0) }
    $F.each { |word| $words[word.downcase] += 1 }
    END     { $words.each { |word, i| printf "%3d %s\n", i, word } }
' |
sort -rn

