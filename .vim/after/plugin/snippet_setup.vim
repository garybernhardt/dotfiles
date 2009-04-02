"remove all snippets from memory so we can source this script after
"modifying our snippets
call NERDSnippetsReset()

"slurp up all our snippets
call NERDSnippetsFromDirectory("~/.vim/snippets")

" Given a string containing a list of arguments (e.g. "one, two = 'test'"),
" this function cleans it up by removing useless whitespace and commas.
function! PyCleanupArgs(text)
    if a:text == 'args'
        return ''
    endif
    let text = substitute(a:text, '\(\w\)\s\(\w\)', '\1,\2', 'g')
    return join(split(text, '\s*,\s*'), ', ')
endfunction

" Given a string containing a list of class name components (e.g. "one two
" three"), this function cleans it up by removing whitespace and camel casing.
function! PyCleanupClassName(text)
    if a:text == 'ClassName'
        return ''
    endif
    let text = substitute(a:text, '\<\(.\)\([^ ]*\)\>', '\U\1\E\2', 'g')
    " let text = substitute(a:text, '\([^ ]\)\([^ ]*\) \([^ ]\)\([^ ]*\)', '\U\1\E\2\U\3\E\4', 'g')
    let text = substitute(text, '\s', '', 'g')
    return text
endfunction

" Given a string containing a list of class name components (e.g. "one two
" three"), this function cleans it up by replacing whitespace with underscores
function! PyCleanupFunctionName(text)
    let text = substitute(a:text, '\s', '_', 'g')
    return text
endfunction
