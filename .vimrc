" This is Gary Bernhardt's .vimrc file
"
" Be warned: this has grown slowly over years and may not be internally
" consistent.

call pathogen#runtime_append_all_bundles()

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
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

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
  " set guifont=Monaco:h14
  set guifont=Inconsolata-dz:h14
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
" set textwidth=78

" GRB: Highlight long lines
" Turn long-line highlighting off when entering all files, then on when
" entering certain files. I don't understand why :match is so stupid that
" setting highlighting when entering a .rb file will cause e.g. a quickfix
" window opened later to have the same match. There doesn't seem to be any way
" to localize it to a file type.
" function! HighlightLongLines()
"   hi LongLine guifg=NONE guibg=NONE gui=undercurl ctermfg=white ctermbg=red cterm=NONE guisp=#FF6C60 " undercurl color
" endfunction
" function! StopHighlightingLongLines()
"   hi LongLine guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE guisp=NONE
" endfunction
" autocmd TabEnter,WinEnter,BufWinEnter * call StopHighlightingLongLines()
" autocmd TabEnter,WinEnter,BufWinEnter *.rb,*.py call HighlightLongLines()
" hi LongLine guifg=NONE
" match LongLine '\%>78v.\+'

" GRB: highlighting search"
set hls

if has("gui_running")
  " GRB: set font"
  ":set nomacatsui anti enc=utf-8 gfn=Monaco:h12

  " GRB: set window size"
  :set lines=100
  :set columns=171

  " GRB: highlight current line"
  :set cursorline
endif

" GRB: set the color scheme
:set t_Co=256 " 256 colors
:set background=dark
:color grb256

" GRB: hide the toolbar in GUI mode
if has("gui_running")
    set go-=T
end

" GRB: add pydoc command
:command! -nargs=+ Pydoc :call ShowPydoc("<args>")
function! ShowPydoc(module, ...)
    let fPath = "/tmp/pyHelp_" . a:module . ".pydoc"
    :execute ":!pydoc " . a:module . " > " . fPath
    :execute ":sp ".fPath
endfunction

" GRB: use emacs-style tab completion when selecting files, etc
set wildmode=longest,list

" GRB: Put useful info in status line
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" GRB: clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" When hitting <;>, complete a snippet if there is one; else, insert an actual
" <;>
function! InsertSnippetWrapper()
    let inserted = TriggerSnippet()
    if inserted == "\<tab>"
        return ";"
    else
        return inserted
    endif
endfunction

if version >= 700
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    let Tlist_Ctags_Cmd='~/bin/ctags'
endif

function! RunTests(target, args)
    silent ! echo
    exec 'silent ! echo -e "\033[1;36mRunning tests in ' . a:target . '\033[0m"'
    silent w
    exec "make " . a:target . " " . a:args
endfunction

function! ClassToFilename(class_name)
    let understored_class_name = substitute(a:class_name, '\(.\)\(\u\)', '\1_\U\2', 'g')
    let file_name = substitute(understored_class_name, '\(\u\)', '\L\1', 'g')
    return file_name
endfunction

function! ModuleTestPath()
    let file_path = @%
    let components = split(file_path, '/')
    let path_without_extension = substitute(file_path, '\.py$', '', '')
    let test_path = 'tests/unit/' . path_without_extension
    return test_path
endfunction

function! NameOfCurrentClass()
    let save_cursor = getpos(".")
    normal $<cr>
    call PythonDec('class', -1)
    let line = getline('.')
    call setpos('.', save_cursor)
    let match_result = matchlist(line, ' *class \+\(\w\+\)')
    let class_name = ClassToFilename(match_result[1])
    return class_name
endfunction

function! TestFileForCurrentClass()
    let class_name = NameOfCurrentClass()
    let test_file_name = ModuleTestPath() . '/test_' . class_name . '.py'
    return test_file_name
endfunction

function! TestModuleForCurrentFile()
    let test_path = ModuleTestPath()
    let test_module = substitute(test_path, '/', '.', 'g')
    return test_module
endfunction

function! RunTestsForFile(args)
    if @% =~ 'test_'
        call RunTests('%', a:args)
    else
        let test_file_name = TestModuleForCurrentFile()
        call RunTests(test_file_name, a:args)
    endif
endfunction

function! RunAllTests(args)
    silent ! echo
    silent ! echo -e "\033[1;36mRunning all unit tests\033[0m"
    silent w
    exec "make!" . a:args
endfunction

function! JumpToError()
    if getqflist() != []
        for error in getqflist()
            if error['valid']
                break
            endif
        endfor
        let error_message = substitute(error['text'], '^ *', '', 'g')
        silent cc!
        exec ":sbuffer " . error['bufnr']
        call RedBar()
        echo error_message
    else
        call GreenBar()
        echo "All tests passed"
    endif
endfunction

function! RedBar()
    hi RedBar ctermfg=white ctermbg=red guibg=red
    echohl RedBar
    echon repeat(" ",&columns - 1)
    echohl
endfunction

function! GreenBar()
    hi GreenBar ctermfg=white ctermbg=green guibg=green
    echohl GreenBar
    echon repeat(" ",&columns - 1)
    echohl
endfunction

function! JumpToTestsForClass()
    exec 'e ' . TestFileForCurrentClass()
endfunction

let mapleader=","
" nnoremap <leader>m :call RunTestsForFile('--machine-out')<cr>:redraw<cr>:call JumpToError()<cr>
" nnoremap <leader>M :call RunTestsForFile('')<cr>
" nnoremap <leader>a :call RunAllTests('--machine-out')<cr>:redraw<cr>:call JumpToError()<cr>
" nnoremap <leader>A :call RunAllTests('')<cr>

" nnoremap <leader>a :call RunAllTests('')<cr>:redraw<cr>:call JumpToError()<cr>
" nnoremap <leader>A :call RunAllTests('')<cr>

" nnoremap <leader>t :call RunAllTests('')<cr>:redraw<cr>:call JumpToError()<cr>
" nnoremap <leader>T :call RunAllTests('')<cr>

" nnoremap <leader>t :call JumpToTestsForClass()<cr>

" highlight current line
set cursorline

set cmdheight=2

" Don't show scroll bars in the GUI
set guioptions-=L
set guioptions-=r

" Use <c-h> for snippets
let g:NERDSnippets_key = '<c-h>'

augroup myfiletypes
  "clear old autocmds in group
  autocmd!
  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et
augroup END

set switchbuf=useopen

autocmd BufRead,BufNewFile *.html source ~/.vim/indent/html_grb.vim
autocmd FileType htmldjango source ~/.vim/indent/html_grb.vim
autocmd! BufRead,BufNewFile *.sass setfiletype sass 

" Map ,e and ,v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'))
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

set number
set numberwidth=5

if has("gui_running")
    " source ~/proj/vim-complexity/repo/complexity.vim
endif

" Seriously, guys. It's not like :W is bound to anything anyway.
command! W :w

map <leader>rm :BikeExtract<cr>

function! ExtractVariable()
    let name = input("Variable name: ")
    if name == ''
        return
    endif
    " Enter visual mode (not sure why this is needed since we're already in
    " visual mode anyway)
    normal! gv

    " Replace selected text with the variable name
    exec "normal c" . name
    " Define the variable on the line above
    exec "normal! O" . name . " = "
    " Paste the original selected text to be the variable value
    normal! $p
endfunction

function! InlineVariable()
    " Copy the variable under the cursor into the 'a' register
    " XXX: How do I copy into a variable so I don't pollute the registers?
    :normal "ayiw
    " It takes 4 diws to get the variable, equal sign, and surrounding
    " whitespace. I'm not sure why. diw is different from dw in this respect.
    :normal 4diw
    " Delete the expression into the 'b' register
    :normal "bd$
    " Delete the remnants of the line
    :normal dd
    " Go to the end of the previous line so we can start our search for the
    " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
    " work; I'm not sure why.
    normal k$
    " Find the next occurence of the variable
    exec '/\<' . @a . '\>'
    " Replace that occurence with the text we yanked
    exec ':.s/\<' . @a . '\>/' . @b
endfunction

vnoremap <leader>rv :call ExtractVariable()<cr>
nnoremap <leader>ri :call InlineVariable()<cr>
" " Find comment
" map <leader>/# /^ *#<cr>
" " Find function
" map <leader>/f /^ *def\><cr>
" " Find class
" map <leader>/c /^ *class\><cr>
" " Find if
" map <leader>/i /^ *if\><cr>
" " Delete function
" " \%$ means 'end of file' in vim-regex-speak
" map <leader>df d/\(^ *def\>\)\\|\%$<cr>
" com! FindLastImport :execute'normal G<CR>' | :execute':normal ?^\(from\|import\)\><CR>'
" map <leader>/m :FindLastImport<cr>

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

" Always show tab bar
set showtabline=2

augroup mkd
    autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
    autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;
augroup END

set makeprg=python\ -m\ nose.core\ --machine-out

map <silent> <leader>y :<C-u>silent '<,'>w !pbcopy<CR>

" Make <leader>' switch between ' and "
nnoremap <leader>' ""yls<c-r>={'"': "'", "'": '"'}[@"]<cr><esc>

" Map keys to go to specific files
map <leader>gr :topleft :split config/routes.rb<cr>
function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . "_ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction
map <leader>gR :call ShowRoutes()<cr>
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
map <leader>gs :CommandTFlush<cr>\|:CommandT public/stylesheets/sass<cr>
map <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
map <leader>gg :topleft 100 :split Gemfile<cr>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>

nnoremap <leader><leader> <c-^>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Running tests
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-makegreen binds itself to ,t unless something else is bound to its
" function.
map <leader>\dontstealmymapsmakegreen :w\|:call MakeGreen('spec')<cr>

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!bundle exec cucumber " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :w\|:!cucumber<cr>
map <leader>C :w\|:!cucumber --profile wip<cr>

set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
" set winheight=5
" set winminheight=5
" set winheight=999

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" nnoremap <c-n> :let &wh = (&wh == 999 ? 10 : 999)<CR><C-W>=

function! ShowColors()
  let num = 255
  while num >= 0
    exec 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
    exec 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
    call append(0, 'ctermbg='.num.':....')
    let num = num - 1
  endwhile
endfunction

command! -range Md5 :echo system('echo '.shellescape(join(getline(<line1>, <line2>), '\n')) . '| md5')

imap <c-l> <space>=><space>

function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\)" | cut -d " " -f 3')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

if &diff
  nmap <c-h> :diffget 1<cr>
  nmap <c-l> :diffget 3<cr>
  nmap <c-k> [cz.
  nmap <c-j> ]cz.
  set nonumber
endif

" In these functions, we don't use the count argument, but the map referencing
" v:count seems to make it work. I don't know why.
function! ScrollOtherWindowDown(count)
  normal! 
  normal! 
  normal! 
endfunction
function! ScrollOtherWindowUp(count)
  normal! 
  normal! 
  normal! 
endfunction
nnoremap g<c-y> :call ScrollOtherWindowUp(v:count)<cr>
nnoremap g<c-e> :call ScrollOtherWindowDown(v:count)<cr>

set shell=bash

" Can't be bothered to understand the difference between ESC and <c-c> in
" insert mode
imap <c-c> <esc>

command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>
