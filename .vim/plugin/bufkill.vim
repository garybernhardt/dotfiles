" bufkill.vim 
" Maintainer:	John Orr (john underscore orr yahoo com)
" Version:	    1.1
" Last Change:	02 December 2004

" Introduction: {{{1
" Basic Usage:
" When you want to unload/delete/wipe a buffer, use:
"   :bun/:bd/:bw to close the window as well (vim command), or
"   :BUN/:BD/:BW to leave the window intact (this script).
" Mappings are also defined.

" Description: 
" This is a script to 
" a) unload, delete or wipe a buffer without closing the window it was displayed in
" b) in its place, display the buffer most recently used in the window, prior
"    to the buffer being killed.  This selection is taken from the full list of 
"    buffers ever displayed in the particular window.
" c) allow one level of undo in case you kill a buffer then change your mind
"
" The inspiration for this script came from
" a) my own frustration with vim's lack of this functionality
" b) the description of the emacs kill-buffer command in tip #622
"    (this script basically duplicates this command I believe,
"    not sure about the undo functionality)
" c) comments by Keith Roberts when the issue was raised in the 
"    vim@vim.org mailing list.

" Install Details:
" The usual - drop this file into your $HOME/.vim/plugin directory (unix)
" or $HOME/vimfiles/plugin directory (Windows), etc.
" Use the commands/mappings defined below to invoke the functionality 
" (or redefine them elsewhere to what you want), and set the 
" User Configurable Variables as desired.  You should be able to make
" any customisations to the controls in your vimrc file, such that 
" updating to new versions of this script won't affect your settings.

" Credits:
" Keith Roberts - for many hours of email discussions, ideas and suggestions
"   to try to get the details as good as possible
" Someone from http://www.cs.albany.edu, who described the functionality of
"   this script in tip #622.

" Possible Improvements:
" If you're particularly interested in any of these, let me know - some are
" definitely planned to happen when time permits:
"
" - Provide a function to save window variables as global variables, 
"   in order to have them preserved by session saving/restoring commands,
"   and then restore the globals to window variables with another function.
"
" - Add a mode (or duplicate to a new script) to save 'views' - where a view
"   is being at a particular place in a particular file, arrived at via 
"   a buffer switch, gf or tag jump.  Allow jumping back to the previous
"   view, and kill (delete, wipe) the file when jumping back past the 
"   last view in that file.
"
" - Allow going forwards again in the buffer list for a window - ie,
"   when removing a buffer, don't delete it from the buffer list, but 
"   instead keep it's info so that we can jump forwards to it again
"   eg in case of a mistake (one level of undo is already implemented).

" Changelog:
" 1.1 - Fix handling of modified, un-named buffers
" 1.0 - initial functionality

" Reload guard and 'compatible' handling {{{1
let s:save_cpo = &cpo
set cpo&vim

if exists("loaded_bufkill")
  finish
endif
let loaded_bufkill = 1

" User configurable variables {{{1
" The following variables can be set in your .vimrc/_vimrc file to override
" those in this file, such that upgrades to the script won't require you to 
" re-edit these variables.
 
" g:BufKillCommandWhenLastBufferKilled {{{2
" When you kill the last buffer that has appeared in a window, something
" has to be displayed if we are to avoid closing the window.  Provide the
" command to be run at this time in this variable.  The default is 'enew', 
" meaning that a blank window will be show, with an empty, 'No File' buffer.
" If this parameter is not set to something valid which changes the buffer
" displayed in the window, the window may be closed.
if !exists('g:BufKillCommandWhenLastBufferKilled')
  let g:BufKillCommandWhenLastBufferKilled = 'enew'
endif

" g:BufKillActionWhenBufferDisplayedInAnotherWindow {{{2
" If the buffer you are attempting to kill in one window is also displayed
" in another, you may not want to kill it afterall.  This option lets you 
" decide how this situation should be handled, and can take one of the following
" values:
"   'kill' - kill the buffer regardless, always
"   'confirm' - ask for confirmation before removing it
"   'cancel' - don't kill it
" Regardless of the setting of this variable, the buffer will always be
" killed if you add an exclamation mark to the command, eg :BD!
if !exists('g:BufKillActionWhenBufferDisplayedInAnotherWindow')
  let g:BufKillActionWhenBufferDisplayedInAnotherWindow = 'confirm' 
endif

" g:BufKillFunctionSelectingValidBuffersToDisplay {{{2
" When a buffer is removed from a window, the script finds the previous 
" buffer displayed in the window.  However, that buffer may have been
" unloaded/deleted/wiped by some other mechanism, so it may not be a 
" valid choice.  For some people, an unloaded buffer may be a valid choice,
" for others, no.  
" - If unloaded buffers should be displayed, set this 
"   variable to 'bufexists'.  
" - If unloaded buffers should not be displayed, set this 
"   variable to 'buflisted' (default).  
" - Setting this variable to 'auto' means that the command :BW will use
"   'bufexists' to decide if a buffer is valid to display, whilst using
"   :BD or :BUN will use 'buflisted'
if !exists('g:BufKillFunctionSelectingValidBuffersToDisplay')
  let g:BufKillFunctionSelectingValidBuffersToDisplay = 'buflisted' 
endif

" g:BufKillVerbose {{{2
" If set to 1, prints extra info about what's being done, why, and how to 
" change it
if !exists('g:BufKillVerbose')
  let g:BufKillVerbose = 1 
endif
 
" g:BufKillListElementSize {{{2
" To keep track of which were the buffers most recently displayed in windows, 
" an array of buffer numbers is stored in a string variable.  This option
" allows you to change the number of characters allocated to store each 
" buffer number.  Default is 5, which means you can have buffer numbers up to 
" 99999 in the list.  If you open more buffers than this in a session, 
" consider increasing this variable.  If you hit problems that the buffer
" order list (w:BufKillList) string is too long, try reducing the value in
" this variable.
if !exists('g:BufKillListElementSize')
  let g:BufKillListElementSize = 5 
endif

" Commands {{{1
"
if !exists(':BUN')
  command -bang BUN   :call <SID>BufKill('bun',"<bang>")
endif
if !exists(':BD')
  command -bang BD    :call <SID>BufKill('bd',"<bang>")
endif
if !exists(':BW')
  command -bang BW    :call <SID>BufKill('bw',"<bang>")
endif
if !exists(':BUNDO')
  command -bang BUNDO :call <SID>UndoKill()
endif

" Keyboard mappings {{{1
"
noremap <Plug>BufKillBun     :call <SID>BufKill('bun', '')<CR>
noremap <Plug>BufKillBunBang :call <SID>BufKill('bun', '!')<CR>
noremap <Plug>BufKillBd      :call <SID>BufKill('bd', '')<CR>
noremap <Plug>BufKillBdBang  :call <SID>BufKill('bd', '!')<CR>
noremap <Plug>BufKillBw      :call <SID>BufKill('bw', '')<CR>
noremap <Plug>BufKillBwBang  :call <SID>BufKill('bw', '!')<CR>
noremap <Plug>BufKillBundo :call <SID>UndoKill()<CR>

if !hasmapto('<Plug>BufKillBun')
  nmap <silent> <unique> <Leader>bun <Plug>BufKillBun
endif
if !hasmapto('<Plug>BufKillBunBang')
  nmap <silent> <unique> <Leader>!bun <Plug>BufKillBunBang
endif
if !hasmapto('<Plug>BufKillBd')
  nmap <silent> <unique> <Leader>bd  <Plug>BufKillBd
endif
if !hasmapto('<Plug>BufKillBdBang')
  nmap <silent> <unique> <Leader>!bd  <Plug>BufKillBdBang
endif
if !hasmapto('<Plug>BufKillBw')
  nmap <silent> <unique> <Leader>bw  <Plug>BufKillBw
endif
if !hasmapto('<Plug>BufKillBwBang')
  nmap <silent> <unique> <Leader>!bw  <Plug>BufKillBwBang
endif
if !hasmapto('<Plug>BufKillBundo')
  nmap <silent> <unique> <Leader>bundo  <Plug>BufKillBundo
endif

function! <SID>BufKill(cmd, bang) "{{{1
" The main function that sparks the removal.
  if !exists('w:BufKillList')
    echoe "BufKill Error: array w:BufKillList does not exist!"
    echoe "Restart vim and retry, and if problems persist, notify the author!"
    return
  endif

  call <SID>SaveWindowPos()

  " Get the buffer to delete - the current one obviously
  let s:BufKillBufferToKill = bufnr('%')
  let s:BufKillBufferToKillPath = expand('%:p')

  " If the buffer is already '[No File]' then doing enew won't create a new
  " buffer, hence the bd/bw command will kill the current buffer and take
  " the window with it... so check for this case
  if bufname('%') == '' && ! &modified
    " No buffer to kill
    return
  endif

  " Just to make sure, check that this matches the last one on the list - else
  " I've stuffed up!
  if s:BufKillBufferToKill != <SID>ArrayGet('w:BufKillList', -1)
    echom "BufKill Warning: bufferToKill = " . s:BufKillBufferToKill . " != last in the list: (" . w:BufKillList. ")"
    echom "Please notify the author of the circumstances of this message!"
  endif

  " If the buffer is modified, and a:bang is not set, give the same kind of
  " error as normal bw
  if &modified && strlen(a:bang) == 0
    echoe "No write since last change for buffer '" . bufname(s:BufKillBufferToKill) . "' (add ! to override)"
    return 
  endif

  " Get a list of all windows which have this buffer loaded
  let s:BufKillWindowListWithBufferLoaded = ''
  let i = 1
  let buf = winbufnr(i)
  while buf != -1
    if buf == s:BufKillBufferToKill
      call <SID>ArrayAdd("s:BufKillWindowListWithBufferLoaded", i)
    endif
    let i = i + 1
    let buf = winbufnr(i)
  endwhile

  " Handle the case where the buffer is displayed in multiple windows
  if <SID>ArrayLen("s:BufKillWindowListWithBufferLoaded") > 1 && strlen(a:bang) == 0
    if g:BufKillActionWhenBufferDisplayedInAnotherWindow =~ '[Cc][Aa][Nn][Cc][Ee][Ll]'
      if g:BufKillVerbose
        echom "Buffer '" . bufname(s:BufKillBufferToKill) . "' displayed in multiple windows - " . a:cmd . " cancelled (add ! to kill anywawy, or set g:BufKillActionWhenBufferDisplayedInAnotherWindow to 'confirm' or 'kill')"
      endif
      return
    elseif g:BufKillActionWhenBufferDisplayedInAnotherWindow =~ '[Cc][Oo][Nn][Ff][Ii][Rr][Mm]'
      let choice = confirm("Buffer '" . bufname(s:BufKillBufferToKill) . "' displayed in multiple windows - " . a:cmd . " it anyway?", "&Yes\n&No", 1)
      if choice != 1
        return 
      endif
    elseif g:BufKillActionWhenBufferDisplayedInAnotherWindow =~ '[Rr][Ee][Mm][Oo][Vv][Ee]'
      if g:BufKillVerbose
        echom "Buffer '" . bufname(s:BufKillBufferToKill) . "' displayed in multiple windows - executing " . a:cmd . " anyway."
      endif
      " Fall through and continue
    endif
  endif

  " For each window that the file is loaded in, go to the previous buffer from its list
  let i = 0
  while i < <SID>ArrayLen("s:BufKillWindowListWithBufferLoaded")
    let win = <SID>ArrayGet("s:BufKillWindowListWithBufferLoaded", i)
    call <SID>GotoPreviousBuffer(win, a:cmd)
    let i = i + 1
  endwhile

  " Restore the cursor to the correct window _before_ removing the buffer,
  " since the buffer removal could have side effects on the windows (eg 
  " minibuffer disappearing due to not enough buffers)
  call <SID>RestoreWindowPos()

  " Kill the old buffer, but save info about it for undo purposes
  let s:BufKillLastWindowListWithBufferLoaded = s:BufKillWindowListWithBufferLoaded
  let s:BufKillLastBufferKilledPath = s:BufKillBufferToKillPath
  let s:BufKillLastBufferKilledNum = s:BufKillBufferToKill
  let killCmd = a:cmd . a:bang . s:BufKillBufferToKill
  exec killCmd

endfunction

function! <SID>GotoPreviousBuffer(win, cmd) "{{{1
  "Function to display the previous buffer for the specified window

  " Go to the right window in which to perform the action 
  if a:win > 0
    exec 'normal ' . a:win . 'w'
  endif

  " Handle the 'auto' setting for 
  " g:BufKillFunctionSelectingValidBuffersToDisplay
  let validityFunction = g:BufKillFunctionSelectingValidBuffersToDisplay
  if validityFunction == 'auto'
    if a:cmd == 'bw'
      let validityFunction = 'bufexists'
    else
      let validityFunction = 'buflisted'
    endif
  endif

  " Find the most recent _listed_ buffer to display
  let newBuffer = <SID>ArrayGet('w:BufKillList', -2)
  exec 'while newBuffer != -1 && !' . validityFunction . '(newBuffer)' 
    call <SID>ArrayDel('w:BufKillList', -2)
    let newBuffer = <SID>ArrayGet('w:BufKillList', -2)
  endwhile
    
  " Handle the case of no valid buffer number to display
  if newBuffer == -1
    let cmd = g:BufKillCommandWhenLastBufferKilled
  else
    let cmd = 'b' . newBuffer
  endif
  exec cmd
endfunction

function! <SID>UndoKill() "{{{1

  if !exists('s:BufKillLastBufferKilledNum') || !exists('s:BufKillLastBufferKilledPath') || s:BufKillLastBufferKilledNum == -1 || s:BufKillLastBufferKilledPath == ''
    echoe 'BufKill: nothing to undo (only one level of undo is supported)'
  else
    if bufexists(s:BufKillLastBufferKilledNum)
      let cmd = 'b' . s:BufKillLastBufferKilledNum
    elseif filereadable(s:BufKillLastBufferKilledPath)
      let cmd = 'e ' . s:BufKillLastBufferKilledPath
    else
      unlet s:BufKillLastBufferKilledNum
      unlet s:BufKillLastBufferKilledPath
      unlet s:BufKillLastWindowListWithBufferLoaded
      echoe 'BufKill: unable to undo. Neither buffer (' . s:BufKillLastBufferKilledNum . ') nor file (' . s:BufKillLastBufferKilledPath . ') could be found.'
    endif

    " For each window the buffer was removed from, show it again
    call <SID>SaveWindowPos()
    let i = 0
    while i < <SID>ArrayLen("s:BufKillLastWindowListWithBufferLoaded")
      let win = <SID>ArrayGet("s:BufKillLastWindowListWithBufferLoaded", i)
      exec 'normal ' . win . 'w'
      exec cmd
      let i = i + 1
    endwhile
    call <SID>RestoreWindowPos()

    unlet s:BufKillLastBufferKilledNum
    unlet s:BufKillLastBufferKilledPath
    unlet s:BufKillLastWindowListWithBufferLoaded
  endif
endfunction

function! <SID>SaveWindowPos() "{{{1
  " Save the current window, to be able to come back to it after doing things
  " in other windows
  let s:BufKillWindowPos = winnr()
endfunction

function! <SID>RestoreWindowPos() "{{{1
  " Restore the window from it's saved config variable
  exec 'normal ' . s:BufKillWindowPos . 'w'
endfunction

function! <SID>UpdateList(event) "{{{1
  " Function to update the window list with info about the current buffer
  if !exists('w:BufKillList')
    let w:BufKillList = ""
  endif
  let bufferNum = bufnr('%')
  " Kill existing occurences
  let existingIndex = <SID>ArrayFindFirst('w:BufKillList', bufferNum)
  if existingIndex != -1
    call <SID>ArrayDel('w:BufKillList', existingIndex)
  endif
  call <SID>ArrayAdd('w:BufKillList', bufferNum)
endfunction


" Auxilliary Functions, arrays etc {{{1
" The list is basically a one dimensional array.  We could use Dave 
" Silvia's 'array.vim' script, but it's big and we don't need that much
" functionality.  So, use a simple string.  For faster access, we want
" each entry in the string to be the same number of chars - so 
" represent a list like 1 3333 2 as
"     1 3333    2
" allowing g:BufKillListElementSize chars for each number.
let s:spaces = '                                               '
function! <SID>ArrayAdd(var,elem) "{{{2
  " Add an element to the end of an array
  if !exists(a:var)
  else
    exec 'let '.a:var.'='.a:var.' . strpart(s:spaces, 0, (g:BufKillListElementSize - strlen(a:elem))) . a:elem'
  endif
endfunction

function! <SID>ArrayIndexIsOutOfBounds(var,index) "{{{2
  " Return a boolean stating if the index was out of bounds for the specified
  " array
  exec 'let maxIndex = strlen(' . a:var . ')/g:BufKillListElementSize - 1'
  let minIndex = (maxIndex * -1) - 1
  if a:index > maxIndex || a:index < minIndex
    return 1
  endif
  return 0
endfunction

function! <SID>ArrayLen(var) "{{{2
  " Get the length of the array
  let len = -1
  if !exists(a:var)
    echoe "ArrayLen Error: array '" . a:var . "' does not exist!"
  else
    exec 'let len = strlen(' . a:var . ') / g:BufKillListElementSize'
  endif
  return len
endfunction

function! <SID>ArrayGet(var,index) "{{{2
  "Get a value from a list array.  Allow negative values,
  "such that -1 gets the last value, etc
  let elem = -1
  if !exists(a:var)
    echoe "ArrayGet Error: array '" . a:var . "' does not exist!"
  elseif <SID>ArrayIndexIsOutOfBounds(a:var, a:index)
    " Fall through - leaving elem set to -1
  else
    let newIndex = a:index
    exec 'let newList = ' . a:var
    if newIndex < 0
      let newIndex =strlen(newList)/g:BufKillListElementSize + newIndex 
    endif
    let elemStr = strpart(newList, newIndex * g:BufKillListElementSize, g:BufKillListElementSize)
    let elem = substitute(elemStr, ' ', '', 'g')
  endif
  " Add 0 to the value to change it from a string to a number
  return elem + 0
endfunction

function! <SID>ArrayDel(var,index) "{{{2
  "Remove element at index a:index from array a:var
  "Allow negative values, as in ArrayGet
  if !exists(a:var)
    echoe "ArrayDel Error: array '" . a:var . "' does not exist!"
  elseif <SID>ArrayIndexIsOutOfBounds(a:var, a:index)
    exec 'echoe "ArrayDel Error: index out of bounds for index = " . a:index . ", array = [" . ' . a:var. '."]"'
  else
    let newIndex = a:index
    exec 'let newList = ' . a:var
    if newIndex < 0
      let newIndex = strlen(newList)/g:BufKillListElementSize + newIndex 
    endif
    let resultList = strpart(newList, 0, newIndex * g:BufKillListElementSize) .
                    \strpart(newList, (newIndex+1) * g:BufKillListElementSize)
    exec 'let ' . a:var . '= resultList'
  endif
endfunction

function! <SID>ArrayPop(var,location) "{{{2
  "Return an element from one end of the array
  "a:location = 0 means from the front, a:location = 1 means from the end
  "Return -1 if not found
  let returnVal = -1
  if !exists(a:var)
    echoe "ArrayPop Error: array '" . a:var . "' does not exist!"
  endif
  exec 'let list = ' . a:var
  if strlen(list)
    if a:location
      let index = strlen(list)/g:BufKillListElementSize - 1
    else
      let index = 0
    endif
    let resultList = strpart(list, 0, index * g:BufKillListElementSize) .
                    \strpart(list, (index+1) * g:BufKillListElementSize)
    let elemStr = strpart(list, (index) * g:BufKillListElementSize, g:BufKillListElementSize)
    exec 'let ' . a:var . '= resultList'
    let elem = substitute(elemStr, ' ', '', 'g')
    let returnVal = elem + 0
  endif
  return returnVal
endfunction


function! <SID>ArrayFindFirst(var,elem) "{{{2
  " Find the first instance of elem in the specified array
  if !exists(a:var)
    echoe "ArrayFindFirst Error: array '" . a:var . "' does not exist!"
  else
    let i = 0
    exec 'let newList = ' . a:var
    let len = strlen(newList)/g:BufKillListElementSize
    while i < len
      let tmp = <SID>ArrayGet(a:var, i)
      if tmp == a:elem
        return i
      endif
      let i = i + 1
    endwhile
  endif
  return -1
endfunction
 
" Autocommands {{{1
"
augroup BufKill
autocmd BufKill WinEnter * call <SID>UpdateList('WinEnter')
autocmd BufKill BufEnter * call <SID>UpdateList('BufEnter')

" Cleanup and modelines {{{1
let &cpo = s:save_cpo

" vim:ft=vim:fdm=marker:fen:fmr={{{,}}}:
