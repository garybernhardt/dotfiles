" Vim compiler file
" Compiler:	Nose unit testing tool for Python
" Maintainer:	Max Ischenko <ischenko@gmail.com>
" Last Change: 2006 Nov 13

if exists("current_compiler")
  finish
endif
let current_compiler = "nose"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat=%f:%l:\ fail:\ %m,%f:%l:\ error:\ %m
CompilerSet makeprg=nosetests\ --machine-out
