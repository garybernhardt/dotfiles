"=============================================================================
" fuzzyfinder.vim : Fuzzy/Partial pattern explorer for
"                   buffer/file/MRU/command/favorite/tag/etc.
"=============================================================================
"
" Author:  Takeshi NISHIDA <ns9tks@DELETE-ME.gmail.com>
" Version: 2.13, for Vim 7.1
" Licence: MIT Licence
" URL:     http://www.vim.org/scripts/script.php?script_id=1984
"
" GetLatestVimScripts: 1984 1 :AutoInstall: fuzzyfinder.vim
"
"=============================================================================
" DOCUMENT: {{{1
"   Japanese: http://vim.g.hatena.ne.jp/keyword/fuzzyfinder.vim
"
"-----------------------------------------------------------------------------
" Description:
"   Fuzzyfinder provides convenient ways to quickly reach the buffer/file you
"   want. Fuzzyfinder finds matching files/buffers with a fuzzy/partial
"   pattern to which it converted the entered pattern.
"
"   E.g.: entered pattern -> fuzzy pattern / partial pattern
"         abc             -> *a*b*c*       / *abc*
"         a?c             -> *a?c*         / *a?c*
"         dir/file        -> dir/*f*i*l*e* / dir/*file*
"         d*r/file        -> d*r/*f*i*l*e* / d*r/*file*
"         ../**/s         -> ../**/*s*     / ../**/*s*
"
"     (** allows searching a directory tree.)
"
"   You will be happy when:
"     "./OhLongLongLongLongLongFile.txt"
"     "./AhLongLongLongLongLongName.txt"
"     "./AhLongLongLongLongLongFile.txt" <- you want :O
"     Type "AF" and "AhLongLongLongLongLongFile.txt" will be select. :D
"
"   Fuzzyfinder has some modes:
"     - Buffer mode
"     - File mode
"     - Directory mode (yet another :cd command)
"     - MRU-file mode (most recently used files)
"     - MRU-command mode (most recently used command-lines)
"     - Favorite-file mode
"     - Tag mode (yet another :tag command)
"     - Tagged-file mode (files which are included in current tags)
"
"   Fuzzyfinder supports the multibyte.
"
"-----------------------------------------------------------------------------
" Installation:
"   Drop this file in your plugin directory.
"
"-----------------------------------------------------------------------------
" Usage:
"   Starting Fuzzyfinder:
"     You can start Fuzzyfinder by the following commands:
"
"       :FuzzyFinderBuffer      - launchs buffer-mode Fuzzyfinder.
"       :FuzzyFinderFile        - launchs file-mode Fuzzyfinder.
"       :FuzzyFinderDir         - launchs directory-mode Fuzzyfinder.
"       :FuzzyFinderMruFile     - launchs MRU-file-mode Fuzzyfinder.
"       :FuzzyFinderMruCmd      - launchs MRU-command-mode Fuzzyfinder.
"       :FuzzyFinderFavFile     - launchs favorite-file-mode Fuzzyfinder.
"       :FuzzyFinderTag         - launchs tag-mode Fuzzyfinder.
"       :FuzzyFinderTaggedFile  - launchs tagged-file-mode Fuzzyfinder.
"
"     It is recommended to map these commands. These commands can take initial
"     text as a command argument. The text will be entered after Fuzzyfinder
"     launched. If a command was executed with a ! modifier (e.g.
"     :FuzzyFinderTag!), it enables the partial matching instead of the fuzzy
"     matching.
"
"
"   In Fuzzyfinder:
"     The entered pattern is converted to the fuzzy pattern and buffers/files
"     which match the pattern is shown in a completion menu.
"
"     A completion menu is shown when you type at the end of the line and the
"     length of entered pattern is more than setting value. By default, it is
"     shown at the beginning.
"
"     If too many items (200, by default) were matched, the completion is
"     aborted to reduce nonresponse.
"
"     If an item were matched with entered pattern exactly, it is shown first.
"     The item whose file name has longer prefix matching is placed upper.
"     Also, an item which matched more sequentially is placed upper. The item
"     whose index were matched with a number suffixed with entered pattern is
"     placed lower. the first item in the completion menu will be selected
"     automatically.
"
"     You can open a selected item in various ways:
"       <CR>  - opens in a previous window.
"       <C-j> - opens in a split window.
"       <C-k> - opens in a vertical-split window.
"       <C-]> - opens in a new tab page.
"     In MRU-command mode, <CR> executes a selected command and others just
"     put it into a command-line. These key mappings are customizable.
"
"     To cancel and return to previous window, leave Insert mode.
"
"     To Switch the mode without leaving Insert mode, use <C-l> or <C-o>.
"     This key mapping is customizable.
"
"     If you want to temporarily change whether or not to ignore case, use
"     <C-t>. This key mapping is customizable.
"
"   To Hide The Completion Temporarily Menu In Fuzzyfinder:
"     You can close it by <C-e> and reopen it by <C-x><C-u>.
"
"   About Highlighting:
"     Fuzzyfinder highlights the buffer with "Error" group when the completion
"     item was not found or the completion process was aborted.
"
"   About Alternative Approach For Tag Jump:
"     Following mappings are replacements for :tag and <C-]>:
"
"       nnoremap <silent> <C-f><C-t> :FuzzyFinderTag!<CR>
"       nnoremap <silent> <C-]>      :FuzzyFinderTag! <C-r>=expand('<cword>')<CR><CR>
"
"     In the tag mode, it is recommended to use partial matching instead of
"     fuzzy matching.
"
"   About Tagged File Mode:
"     The files which are included in the current tags are the ones which are
"     related to the current working environment. So this mode is a pseudo
"     project mode.
"
"   About Usage Of Command Argument:
"     As an example, if you want to launch file-mode Fuzzyfinder with the full
"     path of current directory, map like below:
"
"       nnoremap <C-p> :FuzzyFinderFile <C-r>=fnamemodify(getcwd(), ':p')<CR><CR>
"
"     Instead, if you want the directory of current buffer and not current
"     directory:
"
"       nnoremap <C-p> :FuzzyFinderFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>
"
"   About Abbreviations And Multiple Search:
"     You can use abbreviations and multiple search in each mode. For example,
"     set as below:
"
"       let g:FuzzyFinderOptions.Base.abbrev_map  = {
"             \   "^WORK" : [
"             \     "~/project/**/src/",
"             \     ".vim/plugin/",
"             \   ],
"             \ }
"
"     And type "WORKtxt" in file-mode Fuzzyfinder, then it searches by
"     following patterns:
"
"       "~/project/**/src/*t*x*t*"
"       ".vim/plugin/*t*x*t*"
"
"   Adding Favorite Files:
"     You can add a favorite file by the following commands:
"
"       :FuzzyFinderAddFavFile {filename}
"
"     If you do not specify the filename, current file name is used.
"
"   About Information File:
"     Fuzzyfinder writes information of the MRU, favorite, etc to the file by
"     default (~/.vimfuzzyfinder).

"     :FuzzyFinderEditInfo command is helpful in editing your information
"     file. This command reads the information file in new unnamed buffer.
"     Write the buffer and the information file will be updated.
"
"   About Cache:
"     Once a cache was created, It is not updated automatically to improve
"     response by default. To update it, use :FuzzyFinderRemoveCache command.
"
"   About Migemo:
"     Migemo is a search method for Japanese language.
"
"-----------------------------------------------------------------------------
" Options:
"   You can set options via g:FuzzyFinderOptions which is a dictionary. See
"   the folded section named "GLOBAL OPTIONS:" for details. To easily set
"   options for customization, put necessary entries from GLOBAL OPTIONS into
"   your vimrc file and edit those values.
"
"-----------------------------------------------------------------------------
" Setting Example:
"   let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'FavFile':{}, 'Tag':{}, 'TaggedFile':{}}
"   let g:FuzzyFinderOptions.Base.ignore_case = 1
"   let g:FuzzyFinderOptions.Base.abbrev_map  = {
"         \   '\C^VR' : [
"         \     '$VIMRUNTIME/**',
"         \     '~/.vim/**',
"         \     '$VIM/.vim/**',
"         \     '$VIM/vimfiles/**',
"         \   ],
"         \ }
"   let g:FuzzyFinderOptions.MruFile.max_item = 200
"   let g:FuzzyFinderOptions.MruCmd.max_item = 200
"   nnoremap <silent> <C-n>      :FuzzyFinderBuffer<CR>
"   nnoremap <silent> <C-m>      :FuzzyFinderFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>
"   nnoremap <silent> <C-j>      :FuzzyFinderMruFile<CR>
"   nnoremap <silent> <C-k>      :FuzzyFinderMruCmd<CR>
"   nnoremap <silent> <C-p>      :FuzzyFinderDir <C-r>=expand('%:p:~')[:-1-len(expand('%:p:~:t'))]<CR><CR>
"   nnoremap <silent> <C-f><C-d> :FuzzyFinderDir<CR>
"   nnoremap <silent> <C-f><C-f> :FuzzyFinderFavFile<CR>
"   nnoremap <silent> <C-f><C-t> :FuzzyFinderTag!<CR>
"   nnoremap <silent> <C-f><C-g> :FuzzyFinderTaggedFile<CR>
"   noremap  <silent> g]         :FuzzyFinderTag! <C-r>=expand('<cword>')<CR><CR>
"   nnoremap <silent> <C-f>F     :FuzzyFinderAddFavFile<CR>
"   nnoremap <silent> <C-f><C-e> :FuzzyFinderEditInfo<CR>
"
"-----------------------------------------------------------------------------
" Special Thanks:
"   Vincent Wang
"   Ingo Karkat
"   Nikolay Golubev
"   Brian Doyle
"   id:secondlife
"   Matt Tolton
"
"-----------------------------------------------------------------------------
" ChangeLog:
"   2.13:
"     - Fixed a bug that a directory disappeared when a file in that directroy
"       was being opened in File/Mru-File mode.
"
"   2.12:
"     - Changed to be able to show completion items in the order of recently
"       used in Buffer mode.
"     - Added g:FuzzyFinderOptions.Buffer.mru_order option.
"
"   2.11:
"     - Changed that a dot sequence of entered pattern is expanded to parent
"       directroies in File/Dir mode.
"       E.g.: "foo/...bar" -> "foo/../../bar"
"     - Fixed a bug that a prompt string was excessively inserted.
"
"   2.10:
"     - Changed not to show a current buffer in a completion menu.
"     - Fixed a bug that a filename to open was not been escaped.
"     - Added 'prompt' option.
"     - Added 'prompt_highlight' option.
"     - Removed g:FuzzyFinderOptions.MruFile.no_special_buffer option.
"
"   2.9:
"     - Enhanced <BS> behavior in Fuzzyfinder and added 'smart_bs' option.
"     - Fixed a bug that entered pattern was not been escaped.
"     - Fixed not to insert "zv" with "c/pattern<CR>" command in Normal mode.
"     - Avoid the slow down problem caused by filereadable() check for the MRU
"       information in BufEnter/BufWritePost.
"
"   2.8.1:
"     - Fixed a bug caused by the non-escaped buffer name "[Fuzzyfinder]".
"     - Fixed a command to open in a new tab page in Buffer mode.
"   2.8:
"     - Added 'trim_length' option.
"     - Added 'switch_order' option.
"     - Fixed a bug that entered command did not become the newest in the
"       history.
"     - Fixed a bug that folds could not open with <CR> in a command-line when
"       searching.
"     - Removed 'excluded_indicator' option. Now a completion list in Buffer
"       mode is the same as a result of :buffers.
"
"   2.7:
"     - Changed to find an item whose index is matched with the number
"       suffixed with entered pattern.
"     - Fixed the cache bug after changing current directroy in File mode.
"
"   2.6.2:
"     - Fixed not to miss changes in options when updates the MRU information.
"
"   2.6.1:
"     - Fixed a bug related to floating-point support.
"     - Added support for GetLatestVimScripts.
"
"   2.6:
"     - Revived MRU-command mode. The problem with a command-line abbreviation
"       was solved.
"     - Changed the specification of the information file.
"     - Added :FuzzyFinderEditInfo command.

"   2.5.1:
"     - Fixed to be able to match "foo/./bar" by "foo/**/bar" in File mode.
"     - Fixed to be able to open a space-containing file in File mode.
"     - Fixed to honor the current working directory properly in File mode.
"
"   2.5:
"     - Fixed the bug that a wrong initial text is entered after switching to a
"       next mode.
"     - Fixed the bug that it does not return to previous window after leaving
"       Fuzzyfinder one.
"
"   2.4:
"     - Fixed the bug that Fuzzyfinder fails to open a file caused by auto-cd
"       plugin/script.
"
"   2.3:
"     - Added a key mapping to open items in a new tab page and
"       g:FuzzyFinderOptions.Base.key_open_tab opton.
"     - Changed to show Fuzzyfinder window above last window even if
"       'splitbelow' was set.
"     - Changed to set nocursorline and nocursorcolumn in Fuzzyfinder.
"     - Fixed not to push up a buffer number unlimitedly.
"
"   2.2:
"     - Added new feature, which is the partial matching.
"     - Fixed the bug that an error occurs when "'" was entered.
"
"   2.1:
"     - Restructured the option system AGAIN. Sorry :p
"     - Changed to inherit a typed text when switching a mode without leaving
"       Insert mode.
"     - Changed commands which launch explorers to be able to take a argument
"       for initial text.
"     - Changed to complete file names by relative path and not full path in
"       the buffer/mru-file/tagged-file mode.
"     - Changed to highlight a typed text when the completion item was not
"       found or the completion process was aborted.
"     - Changed to create caches for each tag file and not working directory
"       in the tag/tagged-file mode.
"     - Fixed the bug that the buffer mode couldn't open a unnamed buffer.
"     - Added 'matching_limit' option.
"     - Removed 'max_match' option. Use 'matching_limit' option instead.
"     - Removed 'initial_text' option. Use command argument instead.
"     - Removed the MRU-command mode.
"
"   2.0:
"     - Added the tag mode.
"     - Added the tagged-file mode.
"     - Added :FuzzyFinderRemoveCache command.
"     - Restructured the option system. many options are changed names or
"       default values of some options.
"     - Changed to hold and reuse caches of completion lists by default.
"     - Changed to set filetype 'fuzzyfinder'.
"     - Disabled the MRU-command mode by default because there are problems.
"     - Removed FuzzyFinderAddMode command.
"
"   1.5:
"     - Added the directory mode.
"     - Fixed the bug that it caused an error when switch a mode in Insert
"       mode.
"     - Changed g:FuzzyFinder_KeySwitchMode type to a list.
"
"   1.4:
"     - Changed the specification of the information file.
"     - Added the MRU-commands mode.
"     - Renamed :FuzzyFinderAddFavorite command to :FuzzyFinderAddFavFile.
"     - Renamed g:FuzzyFinder_MruModeVars option to
"       g:FuzzyFinder_MruFileModeVars.
"     - Renamed g:FuzzyFinder_FavoriteModeVars option to
"       g:FuzzyFinder_FavFileModeVars.
"     - Changed to show registered time of each item in MRU/favorite mode.
"     - Added 'timeFormat' option for MRU/favorite modes.
"
"   1.3:
"     - Fixed a handling of multi-byte characters.
"
"   1.2:
"     - Added support for Migemo. (Migemo is Japanese search method.)
"
"   1.1:
"     - Added the favorite mode.
"     - Added new features, which are abbreviations and multiple search.
"     - Added 'abbrevMap' option for each mode.
"     - Added g:FuzzyFinder_MruModeVars['ignoreSpecialBuffers'] option.
"     - Fixed the bug that it did not work correctly when a user have mapped
"       <C-p> or <Down>.
"
"   1.0:
"     - Added the MRU mode.
"     - Added commands to add and use original mode.
"     - Improved the sorting algorithm for completion items.
"     - Added 'initialInput' option to automatically insert a text at the
"       beginning of a mode.
"     - Changed that 'excludedPath' option works for the entire path.
"     - Renamed some options. 
"     - Changed default values of some options. 
"     - Packed the mode-specific options to dictionaries.
"     - Removed some options.
"
"   0.6:
"     - Fixed some bugs.

"   0.5:
"     - Improved response by aborting processing too many items.
"     - Changed to be able to open a buffer/file not only in previous window
"       but also in new window.
"     - Fixed a bug that recursive searching with '**' does not work.
"     - Added g:FuzzyFinder_CompletionItemLimit option.
"     - Added g:FuzzyFinder_KeyOpen option.
"
"   0.4:
"     - Improved response of the input.
"     - Improved the sorting algorithm for completion items. It is based on
"       the matching level. 1st is perfect matching, 2nd is prefix matching,
"       and 3rd is fuzzy matching.
"     - Added g:FuzzyFinder_ExcludePattern option.
"     - Removed g:FuzzyFinder_WildIgnore option.
"     - Removed g:FuzzyFinder_EchoPattern option.
"     - Removed g:FuzzyFinder_PathSeparator option.
"     - Changed the default value of g:FuzzyFinder_MinLengthFile from 1 to 0.
"
"   0.3:
"     - Added g:FuzzyFinder_IgnoreCase option.
"     - Added g:FuzzyFinder_KeyToggleIgnoreCase option.
"     - Added g:FuzzyFinder_EchoPattern option.
"     - Changed the open command in a buffer mode from ":edit" to ":buffer" to
"       avoid being reset cursor position.
"     - Changed the default value of g:FuzzyFinder_KeyToggleMode from
"       <C-Space> to <F12> because <C-Space> does not work on some CUI
"       environments.
"     - Changed to avoid being loaded by Vim before 7.0.
"     - Fixed a bug with making a fuzzy pattern which has '\'.
"
"   0.2:
"     - A bug it does not work on Linux is fixed.
"
"   0.1:
"     - First release.
"
" }}}1
"=============================================================================
" INCLUDE GUARD: {{{1
if exists('loaded_fuzzyfinder') || v:version < 701
  finish
endif
let loaded_fuzzyfinder = 1

" }}}1
"=============================================================================
" FUNCTION: {{{1
"-----------------------------------------------------------------------------
" LIST FUNCTIONS:

function! s:Unique(in)
  let sorted = sort(a:in)
  if len(sorted) < 2
    return sorted
  endif
  let last = remove(sorted, 0)
  let result = [last]
  for item in sorted
    if item != last
      call add(result, item)
      let last = item
    endif
  endfor
  return result
endfunction

" [ [0], [1,2], [3] ] -> [ 0, 1, 2, 3 ]
function! s:Concat(in)
  let result = []
  for l in a:in
    let result += l
  endfor
  return result
endfunction

" [ [ 0, 1 ], [ 2, 3, 4 ], ] -> [ [0,2], [0,3], [0,4], [1,2], [1,3], [1,4] ]
function! s:CartesianProduct(lists)
  if empty(a:lists)
    return []
  endif
  "let result = map((a:lists[0]), '[v:val]')
  let result = [ [] ]
  for l in a:lists
    let temp = []
    for r in result
      let temp += map(copy(l), 'add(copy(r), v:val)')
    endfor
    let result = temp
  endfor
  return result
endfunction

" copy + filter + limit
function! s:FilterEx(in, expr, limit)
  if a:limit <= 0
    return filter(copy(a:in), a:expr)
  endif
  let result = []
  let stride = a:limit * 3 / 2 " x1.5
  for i in range(0, len(a:in) - 1, stride)
    let result += filter(a:in[i : i + stride - 1], a:expr)
    if len(result) >= a:limit
      return remove(result, 0, a:limit - 1)
    endif
  endfor
  return result
endfunction

" 
function! s:FilterMatching(entries, key, pattern, index, limit)
  return s:FilterEx(a:entries, 'v:val[''' . a:key . '''] =~ ' . string(a:pattern) . ' || v:val.index == ' . a:index, a:limit)
endfunction

function! s:ExtendIndexToEach(in, offset)
  for i in range(len(a:in))
    let a:in[i].index = i + a:offset
  endfor
  return a:in
endfunction

function! s:UpdateMruList(mrulist, new_item, key, max_item, excluded)
  let result = copy(a:mrulist)
  let result = filter(result,'v:val[a:key] != a:new_item[a:key]')
  let result = insert(result, a:new_item)
  let result = filter(result, 'v:val[a:key] !~ a:excluded')
  return result[0 : a:max_item - 1]
endfunction

"-----------------------------------------------------------------------------
" STRING FUNCTIONS:

" trims a:str and add a:mark if a length of a:str is more than a:len
function! s:TrimLast(str, len)
  if a:len <= 0 || len(a:str) <= a:len
    return a:str
  endif
  return a:str[:(a:len - len(s:ABBR_TRIM_MARK) - 1)] . s:ABBR_TRIM_MARK
endfunction

" takes suffix numer. if no digits, returns -1
function! s:SuffixNumber(str)
  let s = matchstr(a:str, '\d\+$')
  return (len(s) ? str2nr(s) : -1)
endfunction

function! s:ConvertWildcardToRegexp(expr)
  let re = escape(a:expr, '\')
  for [pat, sub] in [ [ '*', '\\.\\*' ], [ '?', '\\.' ], [ '[', '\\[' ], ]
    let re = substitute(re, pat, sub, 'g')
  endfor
  return '\V' . re
endfunction

" "foo/bar/hoge" -> { head: "foo/bar/", tail: "hoge" }
function! s:SplitPath(path)
  let dir = matchstr(a:path, '^.*[/\\]')
  return  {
        \   'head' : dir,
        \   'tail' : a:path[strlen(dir):]
        \ }
endfunction

function! s:EscapeFilename(fn)
  return escape(a:fn, " \t\n*?[{`$%#'\"|!<")
endfunction

" "foo/.../bar/...hoge" -> "foo/.../bar/../../hoge"
function! s:ExpandTailDotSequenceToParentDir(base)
  return substitute(a:base, '^\(.*[/\\]\)\?\zs\.\(\.\+\)\ze[^/\\]*$',
        \           '\=repeat(".." . s:PATH_SEPARATOR, len(submatch(2)))', '')
endfunction

"-----------------------------------------------------------------------------
" FUNCTIONS FOR COMPLETION ITEM:

function! s:FormatCompletionItem(expr, number, abbr, trim_len, time, base_pattern, evals_path_tail)
  if a:evals_path_tail
    let rate = s:EvaluateMatchingRate(s:SplitPath(matchstr(a:expr, '^.*[^/\\]')).tail,
          \                           s:SplitPath(a:base_pattern).tail)
  else
    let rate = s:EvaluateMatchingRate(a:expr, a:base_pattern)
  endif
  return  {
        \   'word'  : a:expr,
        \   'abbr'  : s:TrimLast((a:number >= 0 ? printf('%2d: ', a:number) : '') . a:abbr, a:trim_len),
        \   'menu'  : printf('%s[%s]', (len(a:time) ? a:time . ' ' : ''), s:MakeRateStar(rate, 5)),
        \   'ranks' : [-rate, (a:number >= 0 ? a:number : a:expr)]
        \ }
endfunction

function! s:EvaluateMatchingRate(expr, pattern)
  if a:expr == a:pattern
    return s:MATCHING_RATE_BASE
  endif
  let rate = 0
  let rate_increment = (s:MATCHING_RATE_BASE * 9) / (len(a:pattern) * 10) " zero divide ok
  let matched = 1
  let i_pattern = 0
  for i_expr in range(len(a:expr))
    if a:expr[i_expr] == a:pattern[i_pattern]
      let rate += rate_increment
      let matched = 1
      let i_pattern += 1
      if i_pattern >= len(a:pattern)
        break
      endif
    elseif matched
      let rate_increment = rate_increment / 2
      let matched = 0
    endif
  endfor
  return rate
endfunction

function! s:MakeRateStar(rate, base)
  let len = (a:base * a:rate) / s:MATCHING_RATE_BASE
  return repeat('*', len) . repeat('.', a:base - len)
endfunction

"-----------------------------------------------------------------------------
" MISC FUNCTIONS:

function! s:IsAvailableMode(mode)
  return exists('a:mode.mode_available') && a:mode.mode_available
endfunction

function! s:GetAvailableModes()
  return filter(values(g:FuzzyFinderMode), 's:IsAvailableMode(v:val)')
endfunction

function! s:GetSortedAvailableModes()
  let modes = filter(items(g:FuzzyFinderMode), 's:IsAvailableMode(v:val[1])')
  let modes = map(modes, 'extend(v:val[1], { "ranks" : [v:val[1].switch_order, v:val[0]] })')
  return sort(modes, 's:CompareRanks')
endfunction

function! s:GetSidPrefix()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

function! s:OnCmdCR()
  for m in s:GetAvailableModes()
    call m.extend_options()
    call m.on_command_pre(getcmdtype() . getcmdline())
  endfor
  " lets last entry become the newest in the history
  if getcmdtype() =~ '[:/=@]'
    call histadd(getcmdtype(), getcmdline())
  endif

  " this is not mapped again (:help recursive_mapping)
  return "\<CR>"
endfunction

function! s:ExpandAbbrevMap(base, abbrev_map)
  let result = [a:base]

  " expand
  for [pattern, sub_list] in items(a:abbrev_map)
    let exprs = result
    let result = []
    for expr in exprs
      let result += map(copy(sub_list), 'substitute(expr, pattern, v:val, "g")')
    endfor
  endfor

  return s:Unique(result)
endfunction

" "**" is expanded to ["**", "."]. E.g.: "foo/**/bar" -> [ "foo/./bar", "foo/**/bar" ]
function! s:ExpandEx(dir)
  if a:dir !~ '\S'
    return ['']
  endif

  " [ ["foo/"], ["**/", "./" ], ["bar/"] ]
  let lists = []
  for i in split(a:dir, '[/\\]\zs')
    let m = matchlist(i, '^\*\{2,}\([/\\]*\)$')
    call add(lists, (empty(m) ? [i] : [i, '.' . m[1]]))
  endfor

  " expand wlidcards
  return split(join(map(s:CartesianProduct(lists), 'expand(join(v:val, ""))'), "\n"), "\n")
endfunction

function! s:EnumExpandedDirsEntries(dir, excluded)
  let dirs = s:ExpandEx(a:dir)
  let entries = s:Concat(map(copy(dirs), 'split(glob(v:val . ".*"), "\n") + ' .
        \                                'split(glob(v:val . "*" ), "\n")'))
  if len(dirs) <= 1
    call map(entries, 'extend(s:SplitPath(v:val), { "suffix" : (isdirectory(v:val) ? s:PATH_SEPARATOR : ""), "head" : a:dir })')
  else
    call map(entries, 'extend(s:SplitPath(v:val), { "suffix" : (isdirectory(v:val) ? s:PATH_SEPARATOR : "") })')
  endif
  if len(a:excluded)
    call filter(entries, '(v:val.head . v:val.tail . v:val.suffix) !~ a:excluded')
  endif
  return entries
endfunction

function! s:GetTagList(tagfile)
  return map(readfile(a:tagfile), 'matchstr(v:val, ''^[^!\t][^\t]*'')')
endfunction

function! s:GetTaggedFileList(tagfile)
  execute 'cd ' . fnamemodify(a:tagfile, ':h')
  let result = map(readfile(a:tagfile), 'fnamemodify(matchstr(v:val, ''^[^!\t][^\t]*\t\zs[^\t]\+''), '':p:~'')')
  cd -
  return result
endfunction

function! s:HighlightPrompt(prompt, highlight)
  syntax clear
  execute printf('syntax match %s /^\V%s/', a:highlight, escape(a:prompt, '\'))
endfunction

function! s:HighlightError()
  syntax clear
  syntax match Error  /^.*$/
endfunction

function! s:CompareTimeDescending(i1, i2)
      return a:i1.time == a:i2.time ? 0 : a:i1.time > a:i2.time ? -1 : +1
endfunction

function! s:CompareRanks(i1, i2)
  if exists('a:i1.ranks') && exists('a:i2.ranks')
    for i in range(min([len(a:i1.ranks), len(a:i2.ranks)]))
      if     a:i1.ranks[i] > a:i2.ranks[i]
        return +1
      elseif a:i1.ranks[i] < a:i2.ranks[i]
        return -1
      endif
    endfor
  endif
  return 0
endfunction

function! s:GetCurrentTagFiles()
  return sort(filter(map(tagfiles(), 'fnamemodify(v:val, '':p'')'), 'filereadable(v:val)'))
endfunction

" }}}1
"=============================================================================
" OBJECT: {{{1
"-----------------------------------------------------------------------------
let g:FuzzyFinderMode = { 'Base' : {} }

function! g:FuzzyFinderMode.Base.launch(initial_text, partial_matching, prev_bufnr, tag_files)
  " initializes this object
  call self.extend_options()
  let self.partial_matching = a:partial_matching
  let self.prev_bufnr = a:prev_bufnr
  let self.tag_files = a:tag_files " to get local value of current buffer
  let self.last_col = -1
  call s:InfoFileManager.load()
  if !s:IsAvailableMode(self)
    echo 'This mode is not available: ' . self.to_str()
    return
  endif

  call s:WindowManager.activate(self.make_complete_func('CompleteFunc'))
  call s:OptionManager.set('completeopt', 'menuone')
  call s:OptionManager.set('ignorecase', self.ignore_case)

  " local autocommands
  augroup FuzzyfinderLocal
    autocmd!
    execute 'autocmd CursorMovedI <buffer>        call ' . self.to_str('on_cursor_moved_i()')
    execute 'autocmd InsertLeave  <buffer> nested call ' . self.to_str('on_insert_leave()'  )
  augroup END

  " local mapping
  for [lhs, rhs] in [
        \   [ self.key_open       , self.to_str('on_cr(0, 0)'            ) ],
        \   [ self.key_open_split , self.to_str('on_cr(1, 0)'            ) ],
        \   [ self.key_open_vsplit, self.to_str('on_cr(2, 0)'            ) ],
        \   [ self.key_open_tab   , self.to_str('on_cr(3, 0)'            ) ],
        \   [ '<BS>'              , self.to_str('on_bs()'                ) ],
        \   [ '<C-h>'             , self.to_str('on_bs()'                ) ],
        \   [ self.key_next_mode  , self.to_str('on_switch_mode(+1)'     ) ],
        \   [ self.key_prev_mode  , self.to_str('on_switch_mode(-1)'     ) ],
        \   [ self.key_ignore_case, self.to_str('on_switch_ignore_case()') ],
        \ ]
    " hacks to be able to use feedkeys().
    execute printf('inoremap <buffer> <silent> %s <C-r>=%s ? "" : ""<CR>', lhs, rhs)
  endfor

  call self.on_mode_enter()

  " Starts Insert mode and makes CursorMovedI event now. Command prompt is
  " needed to forces a completion menu to update every typing.
  call setline(1, self.prompt . a:initial_text)
  call feedkeys("A", 'n') " startinsert! does not work in InsertLeave handler
endfunction

function! g:FuzzyFinderMode.Base.on_cursor_moved_i()
  let ln = getline('.')
  let cl = col('.')
  if !self.exists_prompt(ln)
    " if command prompt is removed
    "call setline('.', self.prompt . ln)
    call setline('.', self.restore_prompt(ln))
    call feedkeys(repeat("\<Right>", len(getline('.')) - len(ln)), 'n')
  elseif cl <= len(self.prompt)
    " if the cursor is moved before command prompt
    call feedkeys(repeat("\<Right>", len(self.prompt) - cl + 1), 'n')
  elseif cl > strlen(ln) && cl != self.last_col
    " if the cursor is placed on the end of the line and has been actually moved.
    let self.last_col = cl
    call feedkeys("\<C-x>\<C-u>", 'n')
  endif
endfunction

function! g:FuzzyFinderMode.Base.on_insert_leave()
  let text = getline('.')
  call self.on_mode_leave()
  call self.empty_cache_if_existed(0)
  call s:OptionManager.restore_all()
  call s:WindowManager.deactivate()

  " switchs to next mode, or finishes fuzzyfinder.
  if exists('s:reserved_switch_mode')
    let m = self.next_mode(s:reserved_switch_mode < 0)
    call m.launch(self.remove_prompt(text), self.partial_matching, self.prev_bufnr, self.tag_files)
    unlet s:reserved_switch_mode
  else
    if exists('s:reserved_command')
      call feedkeys(self.on_open(s:reserved_command[0], s:reserved_command[1]), 'n')
      unlet s:reserved_command
    endif
  endif
endfunction

function! g:FuzzyFinderMode.Base.on_buf_enter()
endfunction

function! g:FuzzyFinderMode.Base.on_buf_write_post()
endfunction

function! g:FuzzyFinderMode.Base.on_command_pre(cmd)
endfunction

function! g:FuzzyFinderMode.Base.on_cr(index, check_dir)
  if pumvisible()
    call feedkeys(printf("\<C-y>\<C-r>=%s(%d, 1) ? '' : ''\<CR>", self.to_str('on_cr'), a:index), 'n')
  elseif !a:check_dir || getline('.') !~ '[/\\]$'
    let s:reserved_command = [self.remove_prompt(getline('.')), a:index]
    call feedkeys("\<Esc>", 'n')
  endif
endfunction

function! g:FuzzyFinderMode.Base.on_bs()
  let bs_count = 1
  if self.smart_bs && col('.') > 2 && getline('.')[col('.') - 2] =~ '[/\\]'
    let bs_count = len(matchstr(getline('.')[:col('.') - 3], '[^/\\]*$')) + 1
  endif
  call feedkeys((pumvisible() ? "\<C-e>" : "") . repeat("\<BS>", bs_count), 'n')
endfunction

function! g:FuzzyFinderMode.Base.on_mode_enter()
endfunction

function! g:FuzzyFinderMode.Base.on_mode_leave()
endfunction

function! g:FuzzyFinderMode.Base.on_open(expr, mode)
  return [
        \   ':edit ',
        \   ':split ',
        \   ':vsplit ',
        \   ':tabedit ',
        \ ][a:mode] . s:EscapeFilename(a:expr) . "\<CR>"
endfunction

function! g:FuzzyFinderMode.Base.on_switch_mode(next_prev)
  let s:reserved_switch_mode = a:next_prev
  call feedkeys("\<Esc>", 'n')
endfunction

function! g:FuzzyFinderMode.Base.on_switch_ignore_case()
  let &ignorecase = !&ignorecase
  echo "ignorecase = " . &ignorecase
  let self.last_col = -1
  call self.on_cursor_moved_i()
endfunction

" export string list
function! g:FuzzyFinderMode.Base.serialize_info()
  let header = self.to_key() . "\t"
  return map(copy(self.info), 'header . string(v:val)')
endfunction

" import related items from string list
function! g:FuzzyFinderMode.Base.deserialize_info(lines)
  let header = self.to_key() . "\t"
  let self.info = map(filter(copy(a:lines), 'v:val[: len(header) - 1] ==# header'),
        \             'eval(v:val[len(header) :])')
endfunction

function! g:FuzzyFinderMode.Base.complete(findstart, base)
  if a:findstart
    return 0
  elseif  !self.exists_prompt(a:base) || len(self.remove_prompt(a:base)) < self.min_length
    return []
  endif
  call s:HighlightPrompt(self.prompt, self.prompt_highlight)
  " FIXME: ExpandAbbrevMap duplicates index
  let result = []
  for expanded_base in s:ExpandAbbrevMap(self.remove_prompt(a:base), self.abbrev_map)
    let result += self.on_complete(expanded_base)
  endfor
  call sort(result, 's:CompareRanks')
  if empty(result)
    call s:HighlightError()
  else
    call feedkeys("\<C-p>\<Down>", 'n')
  endif
  return result
endfunction

" This function is set to 'completefunc' which doesn't accept dictionary-functions.
function! g:FuzzyFinderMode.Base.make_complete_func(name)
  execute printf("function! s:%s(findstart, base)\n" .
        \        "  return %s.complete(a:findstart, a:base)\n" .
        \        "endfunction", a:name, self.to_str())
  return s:GetSidPrefix() . a:name
endfunction

" fuzzy  : 'str' -> {'base':'str', 'wi':'*s*t*r*', 're':'\V\.\*s\.\*t\.\*r\.\*'}
" partial: 'str' -> {'base':'str', 'wi':'*str*', 're':'\V\.\*str\.\*'}
function! g:FuzzyFinderMode.Base.make_pattern(base)
  if self.partial_matching
    let wi = (a:base !~ '^[*?]'  ? '*' : '') . a:base .
          \  (a:base =~ '[^*?]$' ? '*' : '')
    let re = s:ConvertWildcardToRegexp(wi)
    return { 'base': a:base, 'wi':wi, 're': re }
  else
    let wi = ''
    for char in split(a:base, '\zs')
      if wi !~ '[*?]$' && char !~ '[*?]'
        let wi .= '*'. char
      else
        let wi .= char
      endif
    endfor

    if wi !~ '[*?]$'
      let wi .= '*'
    endif

    let re = s:ConvertWildcardToRegexp(wi)

    if self.migemo_support && a:base !~ '[^\x01-\x7e]'
      let re .= '\|\m.*' . substitute(migemo(a:base), '\\_s\*', '.*', 'g') . '.*'
    endif

    return { 'base': a:base, 'wi':wi, 're': re }
  endif
endfunction

" glob with caching-feature, etc.
function! g:FuzzyFinderMode.Base.glob_ex(dir, file, excluded, index, matching_limit)
  let key = fnamemodify(a:dir, ':p')
  call extend(self, { 'cache' : {} }, 'keep')
  if !exists('self.cache[key]')
    echo 'Caching file list...'
    let self.cache[key] = s:EnumExpandedDirsEntries(key, a:excluded)
    call s:ExtendIndexToEach(self.cache[key], 1)
  endif
  echo 'Filtering file list...'
  "return map(s:FilterEx(self.cache[key], 'v:val.tail =~ ' . string(a:file), a:matching_limit),
  return map(s:FilterMatching(self.cache[key], 'tail', a:file, a:index, a:matching_limit),
        \ '{ "index" : v:val.index, "path" : (v:val.head == key ? a:dir : v:val.head) . v:val.tail . v:val.suffix }')
endfunction

function! g:FuzzyFinderMode.Base.glob_dir_ex(dir, file, excluded, index, matching_limit)
  let key = fnamemodify(a:dir, ':p')
  call extend(self, { 'cache' : {} }, 'keep')
  if !exists('self.cache[key]')
    echo 'Caching file list...'
    let self.cache[key] = filter(s:EnumExpandedDirsEntries(key, a:excluded), 'len(v:val.suffix)')
    call insert(self.cache[key], { 'head' : key, 'tail' : '..', 'suffix' : s:PATH_SEPARATOR })
    call insert(self.cache[key], { 'head' : key, 'tail' : '.' , 'suffix' : '' })
    call s:ExtendIndexToEach(self.cache[key], 1)
  endif
  echo 'Filtering file list...'
  "return map(s:FilterEx(self.cache[key], 'v:val.tail =~ ' . string(a:file), a:matching_limit),
  return map(s:FilterMatching(self.cache[key], 'tail', a:file, a:index, a:matching_limit),
        \ '{ "index" : v:val.index, "path" : (v:val.head == key ? a:dir : v:val.head) . v:val.tail . v:val.suffix }')
endfunction

function! g:FuzzyFinderMode.Base.empty_cache_if_existed(force)
  if exists('self.cache') && (a:force || !exists('self.lasting_cache') || !self.lasting_cache)
    unlet self.cache
    "let self.cache = (type(self.cache) == type({}) ? {} :
    "      \           type(self.cache) == type([]) ? [] :
    "      \           type(self.cache) == type('') ? '' : 0)
  endif
endfunction

function! g:FuzzyFinderMode.Base.to_key()
  return filter(keys(g:FuzzyFinderMode), 'g:FuzzyFinderMode[v:val] is self')[0]
endfunction

" returns 'g:FuzzyFinderMode.{key}{.argument}'
function! g:FuzzyFinderMode.Base.to_str(...)
  return 'g:FuzzyFinderMode.' . self.to_key() . (a:0 > 0 ? '.' . a:1 : '')
endfunction

" takes in g:FuzzyFinderOptions
function! g:FuzzyFinderMode.Base.extend_options()
  let n = filter(keys(g:FuzzyFinderMode), 'g:FuzzyFinderMode[v:val] is self')[0]
  call extend(self, g:FuzzyFinderOptions.Base, 'force')
  call extend(self, g:FuzzyFinderOptions[self.to_key()], 'force')
endfunction

function! g:FuzzyFinderMode.Base.next_mode(rev)
  let modes = (a:rev ? s:GetSortedAvailableModes() : reverse(s:GetSortedAvailableModes()))
  let m_last = modes[-1]
  for m in modes
    if m is self
      break
    endif
    let m_last = m
  endfor
  return m_last
  " vim crashed using map()
endfunction

function! g:FuzzyFinderMode.Base.exists_prompt(in)
  return  strlen(a:in) >= strlen(self.prompt) && a:in[:strlen(self.prompt) -1] ==# self.prompt
endfunction

function! g:FuzzyFinderMode.Base.remove_prompt(in)
  return a:in[(self.exists_prompt(a:in) ? strlen(self.prompt) : 0):]
endfunction

function! g:FuzzyFinderMode.Base.restore_prompt(in)
  let i = 0
  while i < len(self.prompt) && i < len(a:in) && self.prompt[i] ==# a:in[i]
    let i += 1
  endwhile
  return self.prompt . a:in[i : ]
endfunction

"-----------------------------------------------------------------------------
let g:FuzzyFinderMode.Buffer = copy(g:FuzzyFinderMode.Base)

function! g:FuzzyFinderMode.Buffer.on_complete(base)
  let patterns = self.make_pattern(a:base)
  let result = s:FilterMatching(self.cache, 'path', patterns.re, s:SuffixNumber(patterns.base), 0)
  return map(result, 's:FormatCompletionItem(v:val.path, v:val.index, v:val.path, self.trim_length, v:val.time, a:base, 1)')
endfunction

function! g:FuzzyFinderMode.Buffer.on_open(expr, mode)
  " attempts to convert the path to the number for handling unnamed buffer
  return printf([
        \   ':%sbuffer',
        \   ':%ssbuffer',
        \   ':vertical :%ssbuffer',
        \   ':tab :%ssbuffer',
        \ ][a:mode] . "\<CR>", filter(self.cache, 'v:val.path == a:expr')[0].buf_nr)
endfunction

function! g:FuzzyFinderMode.Buffer.on_mode_enter()
  let self.cache = map(filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != self.prev_bufnr'),
        \              'self.make_item(v:val)')
  if self.mru_order
    call s:ExtendIndexToEach(sort(self.cache, 's:CompareTimeDescending'), 1)
  endif
endfunction

function! g:FuzzyFinderMode.Buffer.on_buf_enter()
  call self.update_buf_times()
endfunction

function! g:FuzzyFinderMode.Buffer.on_buf_write_post()
  call self.update_buf_times()
endfunction

function! g:FuzzyFinderMode.Buffer.update_buf_times()
  if !exists('self.buf_times')
    let self.buf_times = {}
  endif
  let self.buf_times[bufnr('%')] = localtime()
endfunction

function! g:FuzzyFinderMode.Buffer.make_item(nr)
  return  {
        \   'index'  : a:nr,
        \   'buf_nr' : a:nr,
        \   'path'   : empty(bufname(a:nr)) ? '[No Name]' : fnamemodify(bufname(a:nr), ':~:.'),
        \   'time'   : (exists('self.buf_times[a:nr]') ? strftime(self.time_format, self.buf_times[a:nr]) : ''),
        \ }
endfunction

"-----------------------------------------------------------------------------
let g:FuzzyFinderMode.File = copy(g:FuzzyFinderMode.Base)

function! g:FuzzyFinderMode.File.on_complete(base)
  let base = s:ExpandTailDotSequenceToParentDir(a:base)
  let patterns = map(s:SplitPath(base), 'self.make_pattern(v:val)')
  let result = self.glob_ex(patterns.head.base, patterns.tail.re, self.excluded_path, s:SuffixNumber(patterns.tail.base), self.matching_limit)
  let result = filter(result, 'bufnr("^" . v:val.path . "$") != self.prev_bufnr')
  if len(result) >= self.matching_limit
    call s:HighlightError()
  endif
  return map(result, 's:FormatCompletionItem(v:val.path, v:val.index, v:val.path, self.trim_length, "", base, 1)')
endfunction

"-----------------------------------------------------------------------------
let g:FuzzyFinderMode.Dir = copy(g:FuzzyFinderMode.Base)

function! g:FuzzyFinderMode.Dir.on_complete(base)
  let base = s:ExpandTailDotSequenceToParentDir(a:base)
  let patterns = map(s:SplitPath(base), 'self.make_pattern(v:val)')
  let result = self.glob_dir_ex(patterns.head.base, patterns.tail.re, self.excluded_path, s:SuffixNumber(patterns.tail.base), 0)
  return map(result, 's:FormatCompletionItem(v:val.path, v:val.index, v:val.path, self.trim_length, "", base, 1)')
endfunction

function! g:FuzzyFinderMode.Dir.on_open(expr, mode)
  return ':cd ' . escape(a:expr, ' ') . [
        \   "\<CR>",
        \   "",
        \   "",
        \   "",
        \ ][a:mode]
endfunction

"-----------------------------------------------------------------------------
let g:FuzzyFinderMode.MruFile = copy(g:FuzzyFinderMode.Base)

function! g:FuzzyFinderMode.MruFile.on_complete(base)
  let patterns = self.make_pattern(a:base)
  let result = s:FilterMatching(self.cache, 'path', patterns.re, s:SuffixNumber(patterns.base), 0)
  return map(result, 's:FormatCompletionItem(v:val.path, v:val.index, v:val.path, self.trim_length, v:val.time, a:base, 1)')
endfunction

function! g:FuzzyFinderMode.MruFile.on_mode_enter()
  let self.cache = copy(self.info)
  let self.cache = filter(self.cache, 'bufnr("^" . v:val.path . "$") != self.prev_bufnr')
  let self.cache = filter(self.cache, 'filereadable(v:val.path)')
  let self.cache = map(self.cache, '{ "path" : fnamemodify(v:val.path, ":~:."), "time" : strftime(self.time_format, v:val.time) }')
  let self.cache = s:ExtendIndexToEach(self.cache, 1)
endfunction

function! g:FuzzyFinderMode.MruFile.on_buf_enter()
  call self.update_info()
endfunction

function! g:FuzzyFinderMode.MruFile.on_buf_write_post()
  call self.update_info()
endfunction

function! g:FuzzyFinderMode.MruFile.update_info()
  "if !empty(&buftype) || !filereadable(expand('%'))
  if !empty(&buftype)
    return
  endif
  call s:InfoFileManager.load()
  let self.info = s:UpdateMruList(self.info, { 'path' : expand('%:p'), 'time' : localtime() },
        \                         'path', self.max_item, self.excluded_path)
  call s:InfoFileManager.save()
endfunction

"-----------------------------------------------------------------------------
let g:FuzzyFinderMode.MruCmd = copy(g:FuzzyFinderMode.Base)

function! g:FuzzyFinderMode.MruCmd.on_complete(base)
  let patterns = self.make_pattern(a:base)
  let result = s:FilterMatching(self.cache, 'command', patterns.re, s:SuffixNumber(patterns.base), 0)
  return map(result, 's:FormatCompletionItem(v:val.command, v:val.index, v:val.command, self.trim_length, v:val.time, a:base, 0)')
endfunction

function! g:FuzzyFinderMode.MruCmd.on_open(expr, mode)
  redraw
  " use feedkeys to remap <CR>
  return a:expr . [
        \   "\<C-r>=feedkeys(\"\\<CR>\", 'm')?'':''\<CR>",
        \   "",
        \   "",
        \   "",
        \ ][a:mode]
endfunction

function! g:FuzzyFinderMode.MruCmd.on_mode_enter()
  let self.cache = s:ExtendIndexToEach(map(copy(self.info),
        \ '{ "command" : v:val.command, "time" : strftime(self.time_format, v:val.time) }'), 1)
endfunction

function! g:FuzzyFinderMode.MruCmd.on_command_pre(cmd)
  call self.update_info(a:cmd)
endfunction

function! g:FuzzyFinderMode.MruCmd.update_info(cmd)
  call s:InfoFileManager.load()
  let self.info = s:UpdateMruList(self.info, { 'command' : a:cmd, 'time' : localtime() },
        \                         'command', self.max_item, self.excluded_command)
  call s:InfoFileManager.save()
endfunction

"-----------------------------------------------------------------------------
let g:FuzzyFinderMode.FavFile = copy(g:FuzzyFinderMode.Base)

function! g:FuzzyFinderMode.FavFile.on_complete(base)
  let patterns = self.make_pattern(a:base)
  let result = s:FilterMatching(self.cache, 'path', patterns.re, s:SuffixNumber(patterns.base), 0)
  return map(result, 's:FormatCompletionItem(v:val.path, v:val.index, v:val.path, self.trim_length, v:val.time, a:base, 1)')
endfunction

function! g:FuzzyFinderMode.FavFile.on_mode_enter()
  let self.cache = copy(self.info)
  let self.cache = filter(self.cache, 'bufnr("^" . v:val.path . "$") != self.prev_bufnr')
  let self.cache = map(self.cache, '{ "path" : fnamemodify(v:val.path, ":~:."), "time" : strftime(self.time_format, v:val.time) }')
  let self.cache = s:ExtendIndexToEach(self.cache, 1)
endfunction

function! g:FuzzyFinderMode.FavFile.add(in_file, adds)
  call s:InfoFileManager.load()

  let file = fnamemodify((empty(a:in_file) ? expand('%') : a:in_file), ':p:~')

  call filter(self.info, 'v:val.path != file')
  if a:adds
    call add(self.info, { 'path' : file, 'time' : localtime() })
  endif

  call s:InfoFileManager.save()
endfunction

"-----------------------------------------------------------------------------
let g:FuzzyFinderMode.Tag = copy(g:FuzzyFinderMode.Base)

function! g:FuzzyFinderMode.Tag.on_complete(base)
  let patterns = self.make_pattern(a:base)
  let result = self.find_tag(patterns.re, self.matching_limit)
  if len(result) >= self.matching_limit
    call s:HighlightError()
  endif
  return map(result, 's:FormatCompletionItem(v:val, -1, v:val, self.trim_length, "", a:base, 1)')
endfunction

function! g:FuzzyFinderMode.Tag.on_open(expr, mode)
  return [
        \   ':tjump ',
        \   ':stjump ',
        \   ':vertical :stjump ',
        \   ':tab :stjump ',
        \ ][a:mode] . a:expr . "\<CR>"
endfunction

function! g:FuzzyFinderMode.Tag.find_tag(pattern, matching_limit)
  if !len(self.tag_files)
    return []
  endif

  let key = join(self.tag_files, "\n")

  " cache not created or tags file updated? 
  call extend(self, { 'cache' : {} }, 'keep')
  if !exists('self.cache[key]') || max(map(copy(self.tag_files), 'getftime(v:val) >= self.cache[key].time'))
    echo 'Caching tag list...'
    let self.cache[key] = {
          \   'time' : localtime(),
          \   'data' : s:Unique(s:Concat(map(copy(self.tag_files), 's:GetTagList(v:val)'))),
          \ }
  endif

  echo 'Filtering tag list...'
  return s:FilterEx(self.cache[key].data, 'v:val =~ ' . string(a:pattern), a:matching_limit)
endfunction

"-----------------------------------------------------------------------------
let g:FuzzyFinderMode.TaggedFile = copy(g:FuzzyFinderMode.Base)

function! g:FuzzyFinderMode.TaggedFile.on_complete(base)
  let patterns = self.make_pattern(a:base)
  echo 'Making tagged file list...'
  let result = self.find_tagged_file(patterns.re, self.matching_limit)
  if len(result) >= self.matching_limit
    call s:HighlightError()
  endif
  return map(result, 's:FormatCompletionItem(v:val, -1, v:val, self.trim_length, "", a:base, 1)')
endfunction

function! g:FuzzyFinderMode.TaggedFile.find_tagged_file(pattern, matching_limit)
  if !len(self.tag_files)
    return []
  endif

  let key = join(self.tag_files, "\n")

  " cache not created or tags file updated? 
  call extend(self, { 'cache' : {} }, 'keep')
  if !exists('self.cache[key]') || max(map(copy(self.tag_files), 'getftime(v:val) >= self.cache[key].time'))
    echo 'Caching tagged-file list...'
    let self.cache[key] = {
          \   'time' : localtime(),
          \   'data' : s:Unique(s:Concat(map(copy(self.tag_files), 's:GetTaggedFileList(v:val)'))),
          \ }
  endif

  echo 'Filtering tagged-file list...'
  return s:FilterEx(map(self.cache[key].data, 'fnamemodify(v:val, '':.'')'),
        \               'v:val =~ ' . string(a:pattern),
        \           a:matching_limit)

endfunction

"-----------------------------------------------------------------------------
" sets or restores temporary options
let s:OptionManager = { 'originals' : {} }

function! s:OptionManager.set(name, value)
  call extend(self.originals, { a:name : eval('&' . a:name) }, 'keep')
  execute printf('let &%s = a:value', a:name)
endfunction

function! s:OptionManager.restore_all()
  for [name, value] in items(self.originals)
    execute printf('let &%s = value', name)
  endfor
  let self.originals = {}
endfunction

"-----------------------------------------------------------------------------
" manages buffer/window for fuzzyfinder
let s:WindowManager = { 'buf_nr' : -1 }

function! s:WindowManager.activate(complete_func)
  let self.prev_winnr = winnr()
  let cwd = getcwd()

  if !bufexists(self.buf_nr)
    leftabove 1new
    file `='[Fuzzyfinder]'`
    let self.buf_nr = bufnr('%')
  elseif bufwinnr(self.buf_nr) == -1
    leftabove 1split
    execute self.buf_nr . 'buffer'
    delete _
  elseif bufwinnr(self.buf_nr) != bufwinnr('%')
    execute bufwinnr(self.buf_nr) . 'wincmd w'
  endif

  " countermeasure for auto-cd script
  execute ':lcd ' . cwd

  setlocal filetype=fuzzyfinder
  setlocal bufhidden=delete
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nobuflisted
  setlocal modifiable
  setlocal nocursorline   " for highlighting
  setlocal nocursorcolumn " for highlighting
  let &l:completefunc = a:complete_func

  redraw " for 'lazyredraw'

  " suspend autocomplpop.vim
  if exists(':AutoComplPopLock')
    :AutoComplPopLock
  endif
endfunction

function! s:WindowManager.deactivate()
  " resume autocomplpop.vim
  if exists(':AutoComplPopUnlock')
    :AutoComplPopUnlock
  endif

  close
  execute self.prev_winnr . 'wincmd w'
endfunction

"-----------------------------------------------------------------------------
let s:InfoFileManager = { 'originals' : {} }

function! s:InfoFileManager.load()
  for m in s:GetAvailableModes()
    let m.info = []
  endfor

  try
    let lines = readfile(expand(self.get_info_file()))
  catch /.*/ 
    return
  endtry

  " compatibility check
  if !count(lines, self.get_info_version_line())
      call self.warn_old_info()
      let g:FuzzyFinderOptions.Base.info_file = ''
      return
  endif

  for m in s:GetAvailableModes()
    call m.deserialize_info(lines)
  endfor
endfunction

function! s:InfoFileManager.save()
  let lines = [ self.get_info_version_line() ]
  for m in s:GetAvailableModes()
    let lines += m.serialize_info()
  endfor

  try
    call writefile(lines, expand(self.get_info_file()))
  catch /.*/ 
  endtry
endfunction

function! s:InfoFileManager.edit()

  new
  file `='[FuzzyfinderInfo]'`
  let self.bufnr = bufnr('%')

  setlocal filetype=vim
  setlocal bufhidden=delete
  setlocal buftype=acwrite
  setlocal noswapfile

  augroup FuzzyfinderInfo
    autocmd!
    autocmd BufWriteCmd <buffer> call s:InfoFileManager.on_buf_write_cmd()
  augroup END

  execute '0read ' . expand(self.get_info_file())
  setlocal nomodified

endfunction

function! s:InfoFileManager.on_buf_write_cmd()
  for m in s:GetAvailableModes()
    call m.deserialize_info(getline(1, '$'))
  endfor
  call self.save()
  setlocal nomodified
  execute printf('%dbdelete! ', self.bufnr)
  echo "Information file updated"
endfunction

function! s:InfoFileManager.get_info_version_line()
  return "VERSION\t206"
endfunction

function! s:InfoFileManager.get_info_file()
  return g:FuzzyFinderOptions.Base.info_file
endfunction

function! s:InfoFileManager.warn_old_info()
  echohl WarningMsg
  echo printf("==================================================\n" .
      \       "  Your Fuzzyfinder information file is no longer  \n" .
      \       "  supported. Please remove                        \n" .
      \       "  %-48s\n" .
      \       "==================================================\n" ,
      \       '"' . expand(self.get_info_file()) . '".')
  echohl None
endfunction

" }}}1
"=============================================================================
" GLOBAL OPTIONS: {{{1
" stores user-defined g:FuzzyFinderOptions ------------------------------ {{{2
let user_options = (exists('g:FuzzyFinderOptions') ? g:FuzzyFinderOptions : {})
" }}}2

" Initializes g:FuzzyFinderOptions.
let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'FavFile':{}, 'Tag':{}, 'TaggedFile':{}}
"-----------------------------------------------------------------------------
" [All Mode] This is mapped to select completion item or finish input and
" open a buffer/file in previous window.
let g:FuzzyFinderOptions.Base.key_open = '<CR>'
" [All Mode] This is mapped to select completion item or finish input and
" open a buffer/file in split new window
let g:FuzzyFinderOptions.Base.key_open_split = '<C-j>'
" [All Mode] This is mapped to select completion item or finish input and
" open a buffer/file in vertical-split new window.
let g:FuzzyFinderOptions.Base.key_open_vsplit = '<C-k>'
" [All Mode] This is mapped to select completion item or finish input and
" open a buffer/file in a new tab page.
let g:FuzzyFinderOptions.Base.key_open_tab = '<C-]>'
" [All Mode] This is mapped to switch to the next mode.
let g:FuzzyFinderOptions.Base.key_next_mode = '<C-l>'
" [All Mode] This is mapped to switch to the previous mode.
let g:FuzzyFinderOptions.Base.key_prev_mode = '<C-o>'
" [All Mode] This is mapped to temporarily switch whether or not to ignore
" case.
let g:FuzzyFinderOptions.Base.key_ignore_case = '<C-t>'
" [All Mode] This is the file name to write information of the MRU, etc. If
" "" was set, Fuzzyfinder does not write to the file.
let g:FuzzyFinderOptions.Base.info_file = '~/.vimfuzzyfinder'
" [All Mode] Fuzzyfinder does not start a completion if a length of entered
" text is less than this.
let g:FuzzyFinderOptions.Base.min_length = 0
" [All Mode] This is a dictionary. Each value must be a list. All matchs of a
" key in entered text is expanded with the value.
let g:FuzzyFinderOptions.Base.abbrev_map = {}
" [All Mode] Fuzzyfinder ignores case in search patterns if non-zero is set.
let g:FuzzyFinderOptions.Base.ignore_case = 1
" [All Mode] This is a string to format time string. See :help strftime() for
" details.
let g:FuzzyFinderOptions.Base.time_format = '(%x %H:%M:%S)'
" [All Mode] If a length of completion item is more than this, it is trimmed
" when shown in completion menu.
let g:FuzzyFinderOptions.Base.trim_length = 80
" [All Mode] Fuzzyfinder does not remove caches of completion lists at the end
" of explorer to reuse at the next time if non-zero was set.
let g:FuzzyFinderOptions.Base.lasting_cache = 1
" [All Mode] Fuzzyfinder uses Migemo if non-zero is set.
let g:FuzzyFinderOptions.Base.migemo_support = 0
"-----------------------------------------------------------------------------
" [Buffer Mode] This disables all functions of this mode if zero was set.
let g:FuzzyFinderOptions.Buffer.mode_available = 1
" [Buffer Mode] The prompt string.
let g:FuzzyFinderOptions.Buffer.prompt = '>Buffer>'
" [Buffer Mode] The highlight group name for a prompt string.
let g:FuzzyFinderOptions.Buffer.prompt_highlight = 'Question'
" [Buffer Mode] Pressing <BS> after a path separator deletes one directory
" name if non-zero is set.
let g:FuzzyFinderOptions.Buffer.smart_bs = 1
" [Buffer Mode] The completion items is sorted in the order of recently used
" if non-zero is set.
let g:FuzzyFinderOptions.Buffer.mru_order = 1
" [Buffer Mode] This is used to sort modes for switching to the next/previous
" mode.
let g:FuzzyFinderOptions.Buffer.switch_order = 10
"-----------------------------------------------------------------------------
" [File Mode] This disables all functions of this mode if zero was set.
let g:FuzzyFinderOptions.File.mode_available = 1
" [File Mode] The prompt string.
let g:FuzzyFinderOptions.File.prompt = '>File>'
" [File Mode] The highlight group name for a prompt string.
let g:FuzzyFinderOptions.File.prompt_highlight = 'Question'
" [File Mode] Pressing <BS> after a path separator deletes one directory name
" if non-zero is set.
let g:FuzzyFinderOptions.File.smart_bs = 1
" [File Mode] This is used to sort modes for switching to the next/previous
" mode.
let g:FuzzyFinderOptions.File.switch_order = 20
" [File Mode] The items matching this are excluded from the completion list.
let g:FuzzyFinderOptions.File.excluded_path = '\v\~$|\.o$|\.exe$|\.bak$|\.swp$|((^|[/\\])\.[/\\]$)'
" [File Mode] If a number of matched items was over this, the completion
" process is aborted.
let g:FuzzyFinderOptions.File.matching_limit = 200
"-----------------------------------------------------------------------------
" [Directory Mode] This disables all functions of this mode if zero was set.
let g:FuzzyFinderOptions.Dir.mode_available = 1
" [Directory Mode] The prompt string.
let g:FuzzyFinderOptions.Dir.prompt = '>Dir>'
" [Directory Mode] The highlight group name for a prompt string.
let g:FuzzyFinderOptions.Dir.prompt_highlight = 'Question'
" [Directory Mode] Pressing <BS> after a path separator deletes one directory
" name if non-zero is set.
let g:FuzzyFinderOptions.Dir.smart_bs = 1
" [Directory Mode] This is used to sort modes for switching to the
" next/previous mode.
let g:FuzzyFinderOptions.Dir.switch_order = 30
" [Directory Mode] The items matching this are excluded from the completion
" list.
let g:FuzzyFinderOptions.Dir.excluded_path = '\v(^|[/\\])\.{1,2}[/\\]$'
"-----------------------------------------------------------------------------
" [Mru-File Mode] This disables all functions of this mode if zero was set.
let g:FuzzyFinderOptions.MruFile.mode_available = 1
" [Mru-File Mode] The prompt string.
let g:FuzzyFinderOptions.MruFile.prompt = '>MruFile>'
" [Mru-File Mode] The highlight group name for a prompt string.
let g:FuzzyFinderOptions.MruFile.prompt_highlight = 'Question'
" [Mru-File Mode] Pressing <BS> after a path separator deletes one directory
" name if non-zero is set.
let g:FuzzyFinderOptions.MruFile.smart_bs = 1
" [Mru-File Mode] This is used to sort modes for switching to the
" next/previous mode.
let g:FuzzyFinderOptions.MruFile.switch_order = 40
" [Mru-File Mode] The items matching this are excluded from the completion
" list.
let g:FuzzyFinderOptions.MruFile.excluded_path = '\v\~$|\.bak$|\.swp$'
" [Mru-File Mode] This is an upper limit of MRU items to be stored.
let g:FuzzyFinderOptions.MruFile.max_item = 99
"-----------------------------------------------------------------------------
" [Mru-Cmd Mode] This disables all functions of this mode if zero was set.
let g:FuzzyFinderOptions.MruCmd.mode_available = 1
" [Mru-Cmd Mode] The prompt string.
let g:FuzzyFinderOptions.MruCmd.prompt = '>MruCmd>'
" [Mru-Cmd Mode] The highlight group name for a prompt string.
let g:FuzzyFinderOptions.MruCmd.prompt_highlight = 'Question'
" [Mru-Cmd Mode] Pressing <BS> after a path separator deletes one directory
" name if non-zero is set.
let g:FuzzyFinderOptions.MruCmd.smart_bs = 0
" [Mru-Cmd Mode] This is used to sort modes for switching to the next/previous
" mode.
let g:FuzzyFinderOptions.MruCmd.switch_order = 50
" [Mru-Cmd Mode] The items matching this are excluded from the completion
" list.
let g:FuzzyFinderOptions.MruCmd.excluded_command = '^$'
" [Mru-Cmd Mode] This is an upper limit of MRU items to be stored.
let g:FuzzyFinderOptions.MruCmd.max_item = 99
"-----------------------------------------------------------------------------
" [Favorite-File Mode] This disables all functions of this mode if zero was
" set.
let g:FuzzyFinderOptions.FavFile.mode_available = 1
" [Favorite-File Mode] The prompt string.
let g:FuzzyFinderOptions.FavFile.prompt = '>FavFile>'
" [Favorite-File Mode] The highlight group name for a prompt string.
let g:FuzzyFinderOptions.FavFile.prompt_highlight = 'Question'
" [Favorite-File Mode] Pressing <BS> after a path separator deletes one
" directory name if non-zero is set.
let g:FuzzyFinderOptions.FavFile.smart_bs = 1
" [Favorite-File Mode] This is used to sort modes for switching to the
" next/previous mode.
let g:FuzzyFinderOptions.FavFile.switch_order = 60
"-----------------------------------------------------------------------------
" [Tag Mode] This disables all functions of this mode if zero was set.
let g:FuzzyFinderOptions.Tag.mode_available = 1
" [Tag Mode] The prompt string.
let g:FuzzyFinderOptions.Tag.prompt = '>Tag>'
" [Tag Mode] The highlight group name for a prompt string.
let g:FuzzyFinderOptions.Tag.prompt_highlight = 'Question'
" [Tag Mode] Pressing <BS> after a path separator deletes one directory name
" if non-zero is set.
let g:FuzzyFinderOptions.Tag.smart_bs = 0
" [Tag Mode] This is used to sort modes for switching to the next/previous
" mode.
let g:FuzzyFinderOptions.Tag.switch_order = 70
" [Tag Mode] The items matching this are excluded from the completion list.
let g:FuzzyFinderOptions.Tag.excluded_path = '\v\~$|\.bak$|\.swp$'
" [Tag Mode] If a number of matched items was over this, the completion
" process is aborted.
let g:FuzzyFinderOptions.Tag.matching_limit = 200
"-----------------------------------------------------------------------------
" [Tagged-File Mode] This disables all functions of this mode if zero was set.
let g:FuzzyFinderOptions.TaggedFile.mode_available = 1
" [Tagged-File Mode] The prompt string.
let g:FuzzyFinderOptions.TaggedFile.prompt = '>TaggedFile>'
" [Tagged-File Mode] The highlight group name for a prompt string.
let g:FuzzyFinderOptions.TaggedFile.prompt_highlight = 'Question'
" [Tagged-File Mode] Pressing <BS> after a path separator deletes one
" directory name if non-zero is set.
let g:FuzzyFinderOptions.TaggedFile.smart_bs = 0
" [Tagged-File Mode] This is used to sort modes for switching to the
" next/previous mode.
let g:FuzzyFinderOptions.TaggedFile.switch_order = 80
" [Tagged-File Mode] If a number of matched items was over this, the
" completion process is aborted.
let g:FuzzyFinderOptions.TaggedFile.matching_limit = 200

" overwrites default values of g:FuzzyFinderOptions with user-defined values - {{{2
call map(user_options, 'extend(g:FuzzyFinderOptions[v:key], v:val, ''force'')')
call map(copy(g:FuzzyFinderMode), 'v:val.extend_options()')
" }}}2

" }}}1
"=============================================================================
" COMMANDS/AUTOCOMMANDS/MAPPINGS/ETC.: {{{1

let s:PATH_SEPARATOR = (has('win32') || has('win64') ? '\' : '/')
let s:MATCHING_RATE_BASE = 10000000
let s:ABBR_TRIM_MARK = '...'

augroup FuzzyfinderGlobal
  autocmd!
  autocmd BufEnter     * for m in s:GetAvailableModes() | call m.extend_options() | call m.on_buf_enter() | endfor
  autocmd BufWritePost * for m in s:GetAvailableModes() | call m.extend_options() | call m.on_buf_write_post() | endfor
augroup END

" cnoremap has a problem, which doesn't expand cabbrev.
cmap <silent> <expr> <CR> <SID>OnCmdCR()

command! -bang -narg=? -complete=buffer FuzzyFinderBuffer      call g:FuzzyFinderMode.Buffer.launch    (<q-args>, len(<q-bang>), bufnr('%'), s:GetCurrentTagFiles())
command! -bang -narg=? -complete=file   FuzzyFinderFile        call g:FuzzyFinderMode.File.launch      (<q-args>, len(<q-bang>), bufnr('%'), s:GetCurrentTagFiles())
command! -bang -narg=? -complete=dir    FuzzyFinderDir         call g:FuzzyFinderMode.Dir.launch       (<q-args>, len(<q-bang>), bufnr('%'), s:GetCurrentTagFiles())
command! -bang -narg=? -complete=file   FuzzyFinderMruFile     call g:FuzzyFinderMode.MruFile.launch   (<q-args>, len(<q-bang>), bufnr('%'), s:GetCurrentTagFiles())
command! -bang -narg=? -complete=file   FuzzyFinderMruCmd      call g:FuzzyFinderMode.MruCmd.launch    (<q-args>, len(<q-bang>), bufnr('%'), s:GetCurrentTagFiles())
command! -bang -narg=? -complete=file   FuzzyFinderFavFile     call g:FuzzyFinderMode.FavFile.launch   (<q-args>, len(<q-bang>), bufnr('%'), s:GetCurrentTagFiles())
command! -bang -narg=? -complete=tag    FuzzyFinderTag         call g:FuzzyFinderMode.Tag.launch       (<q-args>, len(<q-bang>), bufnr('%'), s:GetCurrentTagFiles())
command! -bang -narg=? -complete=file   FuzzyFinderTaggedFile  call g:FuzzyFinderMode.TaggedFile.launch(<q-args>, len(<q-bang>), bufnr('%'), s:GetCurrentTagFiles())
command! -bang -narg=? -complete=file   FuzzyFinderEditInfo    call s:InfoFileManager.edit()
command! -bang -narg=? -complete=file   FuzzyFinderAddFavFile  call g:FuzzyFinderMode.FavFile.add(<q-args>, 1)
command! -bang -narg=0                  FuzzyFinderRemoveCache for m in s:GetAvailableModes() | call m.empty_cache_if_existed(1) | endfor

" }}}1
"=============================================================================
" vim: set fdm=marker:
