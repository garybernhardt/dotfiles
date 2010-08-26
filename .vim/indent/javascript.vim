" Vim indent file
" Language:	JavaScript
" Author:	Ryan (ryanthe) Fabella <ryanthe at gmail dot com>
" URL:		-
" Last Change:  2007 september 25

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetJsIndent()
setlocal indentkeys=0{,0},0),:,!^F,o,O,e,*<Return>,=*/
" Clean CR when the file is in Unix format
if &fileformat == "unix" 
    silent! %s/\r$//g
endif
" Only define the functions once per Vim session.
if exists("*GetJsIndent")
    finish 
endif
function! GetJsIndent()
    let pnum = prevnonblank(v:lnum - 1)
    if pnum == 0
       return 0
    endif
    let line = getline(v:lnum)
    let pline = getline(pnum)
    let ind = indent(pnum)
    
    if pline =~ '{\s*$\|[\s*$\|(\s*$'
	let ind = ind + &sw
    endif
    
    if pline =~ ';\s*$' && line =~ '^\s*}'
        let ind = ind - &sw
    endif
    
    if pline =~ '\s*]\s*$' && line =~ '^\s*),\s*$'
      let ind = ind - &sw
    endif

    if pline =~ '\s*]\s*$' && line =~ '^\s*}\s*$'
      let ind = ind - &sw
    endif
    
    if line =~ '^\s*});\s*$\|^\s*);\s*$' && pline !~ ';\s*$'
      let ind = ind - &sw
    endif
    
    if line =~ '^\s*})' && pline =~ '\s*,\s*$'
      let ind = ind - &sw
    endif
    
    if line =~ '^\s*}();\s*$' && pline =~ '^\s*}\s*$'
      let ind = ind - &sw
    endif

    if line =~ '^\s*}),\s*$' 
      let ind = ind - &sw
    endif

    if pline =~ '^\s*}\s*$' && line =~ '),\s*$'
       let ind = ind - &sw
    endif
   
    if pline =~ '^\s*for\s*' && line =~ ')\s*$'
       let ind = ind + &sw
    endif

    if line =~ '^\s*}\s*$\|^\s*]\s*$\|\s*},\|\s*]);\s*\|\s*}]\s*$\|\s*};\s*$\|\s*})$\|\s*}).el$' && pline !~ '\s*;\s*$\|\s*]\s*$' && line !~ '^\s*{' && line !~ '\s*{\s*}\s*'
          let ind = ind - &sw
    endif

    if pline =~ '^\s*/\*'
      let ind = ind + 1
    endif

    if pline =~ '\*/$'
      let ind = ind - 1
    endif
    return ind
endfunction
