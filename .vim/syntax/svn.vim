" Vim syntax file
" Language:	SVN commit file
" Maintainer:	Ben Collins <bcollins@debian.org>
" URL:		XXX
" Last Change:	Tue Oct 22 00:22:19 EDT 2002

" Based on the similar CVS commit file syntax

" Place this file as ~/.vim/syntax/svn.vim
"
" Then add the following lines to ~/.vimrc
"
" au BufNewFile,BufRead  svn-commit.* setf svn

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn cluster svnChange contains=svnAdd,svnDel,svnMod,svnProp
syn match svnLine /^--This line, and those below, will be ignored--$/ skipwhite skipnl skipempty nextgroup=@svnChange
syn match svnAdd /^A[M ]   .*$/ contained skipwhite skipnl skipempty nextgroup=@svnChange 
syn match svnDel /^D[M ]   .*$/ contained skipwhite skipnl skipempty nextgroup=@svnChange 
syn match svnMod /^M[M ]   .*$/ contained skipwhite skipnl skipempty nextgroup=@svnChange 
syn match svnProp /^_[M ]   .*$/ contained skipwhite skipnl skipempty nextgroup=@svnChange 

"The following is the old SVN template format markings
"
"syn region svnLine start="^SVN:" end="$" contains=svnAdd,svnDel,svnMod
"syn match svnAdd   contained "   [A_][ A]   .*"
"syn match svnDel   contained "   [D_][ D]   .*"
"syn match svnMod   contained "   [M_][ M]   .*"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_svn_syn_inits")
	if version < 508
		let did_svn_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

	HiLink svnAdd		Structure
	HiLink svnDel		SpecialChar
	HiLink svnMod		PreProc
	HiLink svnProp		Keyword
	HiLink svnLine		Comment

	delcommand HiLink
endif

let b:current_syntax = "svn"
