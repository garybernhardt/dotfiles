" Vim syntax file
" Language:     SVN log file
" Maintainer:   Adam Lazur <adam@lazur.org>
" URL:          XXX
" Last Change:  $Date: 2005-04-16 23:27:24 -0400 (Sat, 16 Apr 2005) $

" 1) Place this file in ~/.vim/syntax
"
" 2a) Then add the following lines to ~/.vimrc
"
"       au BufNewFile,BufRead  svn-log.* setf svn
"
" 2b) Or for autodetection, make a ~/.vim/scripts.vim with the following:
"
"       if did_filetype()       " filetype already set...
"           finish              " ...then don't do these checks
"       endif
"       if getline(1) =~ /^-\{72}$/
"           setfiletype svnlog
"       endif



" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif


syn match svnLogSeparator /^-\{72}$/ skipwhite skipnl skipempty nextgroup=svnRevision

syn cluster svnLogInfoLine contains=svnRevision,svnLogUser,@svnLogDate,svnLogLines,svnLogInfoSeparator

syn match svnRevision /[r:]\d\+/ contained

syn match svnLogUser /\S\+/ contained
syn match svnLogInfoSeparator /|/ skipwhite nextgroup=@svnLogInfoLine
syn cluster svnLogDate contains=svnLogDateStamp,svnLogDateHuman
syn match svnLogDateStamp /\d\{4}-\d\d-\d\d \d\d:\d\d:\d\d -\d\{4}/ skipwhite nextgroup=svnLogDateHuman
syn match svnLogDateHuman /(.\D\{3} \d\d \D\{3} \d\{4})/he=e-1,hs=s+1 skipwhite nextgroup=svnLogInfoSeparator
syn match svnLogLines /\d\+ lines\?/ skipnl nextgroup=svnChangedPaths,svnLogComment

" Changed paths highlighting
syn region svnChangedPaths start=/^Changed paths:$/ end=/^$/ transparent contains=svnChangeLine,svnChange nextgroup=svnLogComment

syn match svnChangeLine /^Changed paths:$/ skipwhite skipnl skipempty contained nextgroup=@svnChange
syn cluster svnChange contains=svnChangeAdd,svnChangeDel,svnChangeMod,svnChangeCopy
syn match svnChangeDel /^   D .\+$/ contained skipnl nextgroup=@svnChange
syn match svnChangeMod /^   M .\+$/ contained skipnl nextgroup=@svnChange
syn match svnChangeAdd /^   A [^ ]\+/ contained skipnl nextgroup=@svnChange
syn match svnChangeCopy /^   A [^ ]* (from [^)]\+)$/ contained skipnl nextgroup=@svnChange contains=svnRevision

" The comment is a region, we're cheating and swallowing the next
" svnLogSeparator, but we add a contains to it'll highlight okay (breaks
" comments containing svnLogSeparator... but that shouldn't be super common)
syn region svnLogComment start=/\n/ end=/^-\{72}$/ skipnl keepend nextgroup=svnRevision contains=svnLogSeparator


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_svnlog_syn_inits")
    if version < 508
        let did_svnlog_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink svnLogSeparator      Comment
    HiLink svnLogInfoSeparator  Comment
    HiLink svnRevision          Label
    HiLink svnLogUser           Normal
    HiLink svnLogDateStamp      Comment
    HiLink svnLogDateHuman      Comment
    HiLink svnLogLines          Comment

    HiLink svnLogComment        Normal

    HiLink svnChangeLine        Comment
    HiLink svnChangeAdd         Identifier
    HiLink svnChangeDel         WarningMsg
    HiLink svnChangeMod         PreProc
    HiLink svnChangeCopy        SpecialKey


    delcommand HiLink
endif

let b:current_syntax = "svnlog"
