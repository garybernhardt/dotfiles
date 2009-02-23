" ============================================================================
" File:        NERDSnippets.vim
" Description: vim global plugin for snippets that own hard
" Maintainer:  Martin Grenfell <martin_grenfell at msn dot com>
" Last Change: 18 October, 2008
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
"

if v:version < 700
    finish
endif

if exists("loaded_nerd_snippets_plugin")
    finish
endif
let loaded_nerd_snippets_plugin = 1

" Variable Definations: {{{1
" options, define them as you like in vimrc:
if !exists("g:NERDSnippets_key")
    let g:NERDSnippets_key = "<tab>"
endif

if !exists("g:NERDSnippets_marker_start")
    let g:NERDSnippets_marker_start = '<+'
endif
let s:start = g:NERDSnippets_marker_start

if !exists("g:NERDSnippets_marker_end")
    let g:NERDSnippets_marker_end = '+>'
endif
let s:end = g:NERDSnippets_marker_end

let s:in_windows = has("win16") ||  has("win32") || has("win64")

let s:topOfSnippet = -1
let s:appendTab = 1
let s:snippets = {}
let s:snippets['_'] = {}

function! s:enableMaps()
    exec "inoremap ".g:NERDSnippets_key." <c-o>:call NERDSnippets_PreExpand()<cr><c-r>=NERDSnippets_ExpandSnippet()<cr><c-o>:call NERDSnippets_PostExpand()<cr><c-g>u<c-r>=NERDSnippets_SwitchRegion(1)<cr>"
    exec "nnoremap ".g:NERDSnippets_key." i<c-g>u<c-r>=NERDSnippets_SwitchRegion(0)<cr>"
    exec "snoremap ".g:NERDSnippets_key." <esc>i<c-g>u<c-r>=NERDSnippets_SwitchRegion(0)<cr>"
endfunction
command! -nargs=0 NERDSnippetsEnable call <SID>enableMaps()
call s:enableMaps()

function! s:disableMaps()
    exec "iunmap ".g:NERDSnippets_key
    exec "nunmap ".g:NERDSnippets_key
    exec "sunmap ".g:NERDSnippets_key
endfunction
command! -nargs=0 NERDSnippetsDisable call <SID>disableMaps()

" Snippet class {{{1
let s:Snippet = {}

function! s:Snippet.New(expansion, ...)
    let newSnippet = copy(self)
    let newSnippet.expansion = a:expansion
    if a:0
        let newSnippet.name = a:1
    else
        let newSnippet.name = ''
    endif
    return newSnippet
endfunction

function! s:Snippet.stringForPrompt()
    if self.name != ''
        return self.name
    else
        return substitute(self.expansion, "\r", '<CR>', 'g')
    endif
endfunction
"}}}1

function! NERDSnippets_ExpandSnippet()
    let snippet_name = substitute(getline('.')[:(col('.')-2)],'\zs.*\W\ze\w*$','','g')
    let snippet = s:snippetFor(snippet_name)
    if snippet != ''
        let s:appendTab = 0
        let s:topOfSnippet = line('.')
        let snippet = "\<c-o>ciw" . snippet
    else
        let s:appendTab = 1
    endif
    return snippet
endfunction

function! NERDSnippets_PreExpand()
    let b:NERDSnippets_old_format_options = &fo
    setl fo-=t
    setl fo-=c
    setl fo-=r
    setl fo-=a
    setl fo-=n
endfunction

function! NERDSnippets_PostExpand()
    let &l:fo = b:NERDSnippets_old_format_options
endfunction

"jump to the next marker, remove the delimiters and select the text inside in
"select mode
"
"if no markers are found, a <tab> may be inserted into the text
function! NERDSnippets_SwitchRegion(allowAppend)
    if s:topOfSnippet != -1
        call cursor(s:topOfSnippet,1)
        let s:topOfSnippet = -1
    endif

    try
        let markerPos = s:nextMarker()
        let markersEmpty = stridx(getline("."), s:start.s:end) == markerPos[0]-1

        let removedMarkers = 0
        if s:removeMarkers()
            let markerPos[1] -= (strlen(s:start) + strlen(s:end))
            let removedMarkers = 1
        endif

        call cursor(line("."), markerPos[0])
        normal! v
        call cursor(line("."), markerPos[1] + strlen(s:end) - 1 + (&selection == "exclusive"))

        if removedMarkers && markersEmpty
            return "\<right>"
        else
            return "\<c-\>\<c-n>gvo\<c-g>"
        endif

    catch /NERDSnippets.NoMarkersFoundError/
        if s:appendTab && a:allowAppend
            if g:NERDSnippets_key == "<tab>"
                return "\<tab>"
            endif
        endif
        "we were called from normal mode so return to normal and move the
        "cursor forward again
        return "\<ESC>l"
    endtry
endfunction

"jump the cursor to the start of the next marker and return an array of the
"for [start_column, end_column], where start_column points to the start of
"<+ and end_column points to the start of +>
function! s:nextMarker()
    let start = searchpos('\V'.s:start.'\.\{-\}'.s:end, 'c')[1]
    if start == 0
        throw "NERDSnippets.NoMarkersFoundError"
    endif

    let l = getline(".")
    let balance = 0
    let i = start-1
    while i < strlen(l)
        if strpart(l, i, strlen(s:start)) == s:start
            let balance += 1
        elseif strpart(l, i, strlen(s:end)) == s:end
            let balance -= 1
        endif

        if balance == 0
            "add 1 for 'string index' => 'column number' conversion
            return [start,i+1]
        endif

        let i += 1

    endwhile
    throw "NERDSnippets.MalformedMarkersError"
endfunction

"asks the user to select a snippet from the given list
"
"returns the body of the chosen snippet
function! s:chooseSnippet(snippets)
    "build the dialog/choice list
    let prompt = ""
    let i = 0
    while i < len(a:snippets)
        let prompt .= i+1 . ". " . a:snippets[i].stringForPrompt() . "\n"
        let i += 1
    endwhile
    let prompt .= "\nSelect a snippet:"

    "input(save|restore) needed because this function is called during a
    "mapping
    redraw!
    call inputsave()
    if len(a:snippets) < 10
        echon prompt
        let choice = nr2char(getchar())
    else
        let choice = input(prompt)
    endif
    call inputrestore()
    redraw!

    if choice !~ '^\d*$' || choice < 1 || choice > len(a:snippets)
        return ""
    endif

    return a:snippets[choice-1].expansion
endfunction

"get a snippet for the given keyword, if multiple snippets are found then prompt
"the user to choose.
"
"if no snippets are found, return ''
function! s:snippetFor(keyword)
    let snippets = []
    if has_key(s:snippets,&ft)
        if has_key(s:snippets[&ft],a:keyword)
            let snippets = extend(snippets, s:snippets[&ft][a:keyword])
        endif
    endif
    if has_key(s:snippets['_'],a:keyword)
        let snippets = extend(snippets, s:snippets['_'][a:keyword])
    endif

    if len(snippets)
        if len(snippets) == 1
            return snippets[0].expansion
        else
            return s:chooseSnippet(snippets)
        endif
    endif

    return ''
endfunction

"removes a set of markers from the current cursor postion
"
"i.e. turn this
"   foo <+foobar+> foo

"into this
"
"  foo foobar foo
function! s:removeMarkers()
    try
        let marker = s:nextMarker()
        if strpart(getline('.'), marker[0]-1, strlen(s:start)) == s:start

            "remove them
            let line = getline(".")
            let start = marker[0] - 1
            let startOfBody = start + strlen(s:start)
            let end = marker[1] - 1
            let line = strpart(line, 0, start) .
                        \ strpart(line, startOfBody, end - startOfBody) .
                        \ strpart(line, end+strlen(s:end))
            call setline(line("."), line)
            return 1
        endif
    catch /NERDSnippets.NoMarkersFoundError/
    endtry
endfunction

"add a new snippet for the given filetype and keyword
function! s:addSnippet(filetype, keyword, expansion, ...)
    if !has_key(s:snippets, a:filetype)
        let s:snippets[a:filetype] = {}
    endif

    if !has_key(s:snippets[a:filetype], a:keyword)
        let s:snippets[a:filetype][a:keyword] = []
    endif

    let snippetName = ''
    if a:0
        let snippetName = a:1
    endif

    let newSnippet = s:Snippet.New(a:expansion, snippetName)

    call add(s:snippets[a:filetype][a:keyword], newSnippet)
endfunction

"remove all snippets
function! NERDSnippetsReset()
    let s:snippets = {}
    let s:snippets['_'] = {}
endfunction


"Extract snippets from the given directory. The snippet filetype, keyword, and
"possibly name, are all inferred from the path of the .snippet files relative
"to a:dir.
function! NERDSnippetsFromDirectory(dir)
    let snippetFiles = split(globpath(expand(a:dir), '**/*.snippet'), '\n')
    for fullpath in snippetFiles
        let tail = strpart(fullpath, strlen(expand(a:dir)))

        if s:in_windows
            let tail = substitute(tail, '\\', '/', 'g')
        endif

        let filetype = substitute(tail, '^/\([^/]*\).*', '\1', '')
        let keyword = substitute(tail, '^/[^/]*\(.*\)', '\1', '')
        call s:extractSnippetFor(fullpath, filetype, keyword)
    endfor
endfunction

"Extract snippets from the given directory for the given filetype.
"
"The snippet keywords (and possibly names) are interred from the path of the
".snippet files relative to a:dir
function! NERDSnippetsFromDirectoryForFiletype(dir, filetype)
    let snippetFiles = split(globpath(expand(a:dir), '**/*.snippet'), '\n')
    for i in snippetFiles
        let base = expand(a:dir)
        let fullpath = expand(i)
        let tail = strpart(fullpath, strlen(base))

        if s:in_windows
            let tail = substitute(tail, '\\', '/', 'g')
        endif

        call s:extractSnippetFor(fullpath, a:filetype, tail)
    endfor
endfunction

"create a snippet from the given file
"
"Args:
"fullpath: full path to snippet file
"filetype: the filetype for the new snippet
"tail: the last part of the path containing the keyword and possibly name. eg
" '/class.snippet'   or  '/class/with_constructor.snippet'
function! s:extractSnippetFor(fullpath, filetype, tail)
    let keyword = ""
    let name = ""

    let slashes = strlen(substitute(a:tail, '[^/]', '', 'g'))
    if slashes == 1
        let keyword = substitute(a:tail, '^/\(.*\)\.snippet', '\1', '')
    elseif slashes == 2
        let keyword = substitute(a:tail, '^/\([^/]*\)/.*$', '\1', '')
        let name = substitute(a:tail, '^/[^/]*/\(.*\)\.snippet', '\1', '')
    else
        throw 'NERDSnippets.ScrewedSnippetPathError ' . a:fullpath
    endif

    let snippetContent = s:parseSnippetFile(a:fullpath)

    call s:addSnippet(a:filetype, keyword, snippetContent, name)
endfunction


"Extract and munge the body of the snippet from the given file.
function! s:parseSnippetFile(path)
    try
        let lines = readfile(a:path)
    catch /E484/
        throw "NERDSnippet.ScrewedSnippetPathError " . a:path
    endtry

    let i = 0
    while i < len(lines)
        "add \<CR> to the end of the lines, but not the last line
        if i < len(lines)-1
            let lines[i] = substitute(lines[i], '$', '\1' . "\<CR>", "")
        endif

        "remove leading whitespace
        let lines[i] = substitute(lines[i], '^\s*', '', '')

        "make \<C-R>= function in the templates
        let lines[i] = substitute(lines[i], '\c\\<c-r>=', "\<c-r>=", "g")

        "make \<C-O>= function in the templates
        let lines[i] = substitute(lines[i], '\c\\<c-o>', "\<c-o>", "g")

        "make \<CR> function in templates
        let lines[i] = substitute(lines[i], '\c\\<cr>', "\<cr>", "g")

        let i += 1
    endwhile

    return join(lines, '')
endfunction

"some global functions that are handy inside snippet files {{{1
function! NS_prompt(varname, prompt, default)
    "input(save|restore) needed because this function is called during a
    "mapping
    call inputsave()
    let input = input(a:prompt . ':', a:default)
    exec "let g:" . a:varname . "='" . escape(input, "'") . "'"
    call inputrestore()
    redraw!
    return input
endfunction

function! NS_camelcase(s)
    "upcase the first letter
    let toReturn = substitute(a:s, '^\(.\)', '\=toupper(submatch(1))', '')
    "turn all '_x' into 'X'
    return substitute(toReturn, '_\(.\)', '\=toupper(submatch(1))', 'g')
endfunction

function! NS_underscore(s)
    "down the first letter
    let toReturn = substitute(a:s, '^\(.\)', '\=tolower(submatch(1))', '')
    "turn all 'X' into '_x'
    return substitute(toReturn, '\([A-Z]\)', '\=tolower("_".submatch(1))', 'g')
endfunction
"}}}

" vim: set ft=vim ff=unix fdm=marker :
