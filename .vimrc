" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" Remember more commands and search history
set history=1000

" Make tab completion for files/buffers act like bash
set wildmenu
set wildmode=list:longest

" Make searches case-sensitive only if they contain upper-case characters
set ignorecase
set smartcase

" Keep more context when scrolling off the end of a buffer
set scrolloff=3

" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


" GRB: sane editing configuration"
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
" set smartindent
set laststatus=2
set showmatch
set incsearch

" GRB: wrap lines at 78 characters
set textwidth=78

" GRB: highlighting search"
set hls

if has("gui_running")
  " GRB: set font"
  ":set nomacatsui anti enc=utf-8 gfn=Monaco:h12

  " GRB: set window size"
  :set lines=100
  :set columns=157

  " GRB: highlight current line"
  :set cursorline
endif

" GRB: set the color scheme
if !has("gui_running")
    :color grb2
endif

" GRB: add pydoc command
:command -nargs=+ Pydoc :call ShowPydoc("<args>") 
function ShowPydoc(module, ...) 
    let fPath = "/tmp/pyHelp_" . a:module . ".pydoc" 
    :execute ":!pydoc " . a:module . " > " . fPath 
    :execute ":sp ".fPath 
endfunction 

" GRB: Always source python.vim for Python files
au FileType python source ~/.vim/scripts/python.vim

" GRB: Use custom python.vim syntax file
au! Syntax python source ~/.vim/syntax/python.vim
let python_highlight_all = 1
let python_slow_sync = 1

" GRB: Add to syntax/python.vim to highlight more errors
syn match pythonError	 "^\s*def\s\+\w\+(.*)\s*$" display 
syn match pythonError	 "^\s*class\s\+\w\+(.*)\s*$" display 
syn match pythonError	 "^\s*for\s.*[^:]$" display 
syn match pythonError	 "^\s*except\s*$" display 
syn match pythonError	 "^\s*finally\s*$" display 
syn match pythonError	 "^\s*try\s*$" display 
syn match pythonError	 "^\s*else\s*$" display 
syn match pythonError	 "^\s*else\s*[^:].*" display 
syn match pythonError	 "^\s*if\s.*[^\:]$" display 
syn match pythonError	 "^\s*except\s.*[^\:]$" display 
syn match pythonError	 "[;]$" display 
syn keyword pythonError         do 

" GRB: use emacs-style tab completion when selecting files, etc
set wildmode=longest,list

" GRB: Put useful info in status line
:set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ %-19(%3l,%02c%03V%)%O'%02b'
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" GRB: clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<CR>/<BS>

" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function InsertTabWrapper() 
    let col = col('.') - 1 
    if !col || getline('.')[col - 1] !~ '\k' 
        return "\<tab>" 
    else 
        return "\<c-p>"
    endif 
endfunction 
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" Use semicolon for snippets
let g:snippetsEmu_key = ';'

if version >= 700
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    let Tlist_Ctags_Cmd='~/bin/ctags'
endif

" GRB: use fancy buffer closing that doesn't close the split
cnoremap <expr> bd (getcmdtype() == ':' ? 'Bclose' : 'bd')

function! TestsForFile()
    silent ! echo
    silent ! echo -e "\033[1;36mRunning tests for %\033[0m"
    set makeprg=scripts/tests\ --with-doctest\ --machine-out\ -x
    silent w
    silent make %
    redraw!
    if getqflist() != []
        cc!
    else
        echo "All tests passed"
    endif
endfunction

function! AllTests()
    silent ! echo
    silent ! echo -e "\033[1;36mRunning all unit tests\033[0m"
    set makeprg=scripts/tests\ --with-doctest\ -x\ -v
    silent w
    make tests.unit
endfunction

let mapleader=","
nnoremap <leader>m :call TestsForFile()<cr>
nnoremap <leader>M :call AllTests()<cr>
nnoremap <leader><leader> <c-^>

" highlight current line
set cursorline
hi CursorLine cterm=NONE ctermbg=black

