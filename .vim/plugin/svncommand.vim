" vim600: set foldmethod=marker:
"
" $Id: svncommand.vim 29 2005-04-19 00:22:27Z laz $
"
" Vim plugin to assist in working with SVN-controlled files.
"
" Last Change:   $Date: 2005-04-18 20:22:27 -0400 (Mon, 18 Apr 2005) $
" Version:       1.67.3
" Maintainer:    Adam Lazur <adam@lazur.org>
" License:       This file is placed in the public domain.
" Credits:       Bob Hiestand and all the cvscommand.vim credits.
"
"                Various people who've emailed with valuable feedback about
"                svncommand.vim.
"
" Config Note:   I chose not to deviate from the cvscommand.vim defaults, but
"                I do recommend tweaking the user variables. I personally use:
"
"                let SVNCommandEnableBufferSetup=1
"                let SVNCommandCommitOnWrite=1
"                let SVNCommandEdit='split'
"                let SVNCommandNameResultBuffers=1
"                let SVNCommandAutoSVK='svk'
"
" Section: Documentation {{{1
"
" This is mostly a s/CVS/SVN/g on cvscommand.vim by Bob Hiestand
" <bob@hiestandfamily.org> with some svn translations for various things.
" Most notable removals are support for cvs edit and watching, both of which
" subversion does not support.
"
" Provides functions to invoke various SVN commands on the current file.
" The output of the commands is captured in a new scratch window.  For
" convenience, if the functions are invoked on a SVN output window, the
" original file is used for the svn operation instead after the window is
" split.  This is primarily useful when running SVNCommit and you need to see
" the changes made, so that SVNDiff is usable and shows up in another window.
"
" Command documentation {{{2
"
" SVNAdd           Performs "svn add" on the current file.
"
" SVNAnnotate      Performs "svn annotate" on the current file.  If an
"                  argument is given, the argument is used as a revision
"                  number to display.  If not given an argument, it uses the
"                  most recent version of the file on the current branch.
"                  Additionally, if the current buffer is a SVNAnnotate buffer
"                  already, the version number just prior to the one on the
"                  current line is used.  This allows one to navigate back to
"                  examine the previous version of a line.
"
" SVNCommit        This is a two-stage command.  The first step opens a buffer to
"                  accept a log message.  When that buffer is written, it is
"                  automatically closed and the file is committed using the
"                  information from that log message.  If the file should not be
"                  committed, just destroy the log message buffer without writing
"                  it.
"
" SVNDiff          With no arguments, this performs "svn diff" on the current
"                  file.  With one argument, "svn diff" is performed on the
"                  current file against the specified revision.  With two
"                  arguments, svn diff is performed between the specified
"                  revisions of the current file.  This command uses the
"                  'SVNCommandDiffOpt' variable to specify diff options.  If
"                  that variable does not exist, then '' is assumed.  If
"                  you wish to have no options, then set it to the empty
"                  string.
"
" SVNGotoOriginal  Returns the current window to the source buffer if the
"                  current buffer is a SVN output buffer.
"
" SVNLog           Performs "svn log" on the current file.
"
" SVNRevert        Replaces the modified version of the current file with the
"                  most recent version from the repository.
"
" SVNReview        Retrieves a particular version of the current file.  If no
"                  argument is given, the most recent version of the file on
"                  the current branch is retrieved.  The specified revision is
"                  retrieved into a new buffer.
"
" SVNStatus        Performs "svn status -v" on the current file.
"
" SVNStatus        Performs "svn info" on the current file.
"
" SVNUpdate        Performs "svn update" on the current file.
"
" SVNVimDiff       With no arguments, this prompts the user for a revision and
"                  then uses vimdiff to display the differences between the
"                  current file and the specified revision.  If no revision is
"                  specified, the most recent version of the file on the
"                  current branch is used.  With one argument, that argument
"                  is used as the revision as above.  With two arguments, the
"                  differences between the two revisions is displayed using
"                  vimdiff.
"
"                  With either zero or one argument, the original buffer is used
"                  to perform the vimdiff.  When the other buffer is closed, the
"                  original buffer will be returned to normal mode.
" SVNCommitDiff
"               Will parse the commit buffer (that should be autogenerated by
"               svn), and split the window with a corresponding diff. It is
"               highly convenient to review a diff when writing the log
"               message.
"
"               You may want to setup an autocommand in your vimrc like so:
"
"                   au BufNewFile,BufRead  svn-commit.* setf svn
"                   au FileType svn map <Leader>sd :SVNCommitDiff<CR>
"
"
" Mapping documentation: {{{2
"
" By default, a mapping is defined for each command.  User-provided mappings
" can be used instead by mapping to <Plug>CommandName, for instance:
"
" nnoremap ,ca <Plug>SVNAdd
"
" The default mappings are as follow:
"
"   <Leader>sa SVNAdd
"   <Leader>sn SVNAnnotate
"   <Leader>sc SVNCommit
"   <Leader>sd SVNDiff
"   <Leader>sg SVNGotoOriginal
"   <Leader>sG SVNGotoOriginal!
"   <Leader>sl SVNLog
"   <Leader>sr SVNReview
"   <Leader>ss SVNStatus
"   <Leader>si SVNInfo
"   <Leader>su SVNUpdate
"   <Leader>sv SVNVimDiff
"
" Options documentation: {{{2
"
" Several variables are checked by the script to determine behavior as follow:
"
" SVNCommandCommitOnWrite
"   This variable, if set to a non-zero value, causes the pending svn commit
"   to take place immediately as soon as the log message buffer is written.
"   If set to zero, only the SVNCommit mapping will cause the pending commit
"   to occur.  If not set, it defaults to 1.
"
" SVNCommandDeleteOnHide
"   This variable, if set to a non-zero value, causes the temporary SVN result
"   buffers to automatically delete themselves when hidden.
"
" SVNCommandDiffOpt
"   This variable, if set, determines the options passed to the diff command
"   of SVN.  If not set, it defaults to 'wbBc'.
"
" SVNCommandDiffSplit
"   This variable overrides the SVNCommandSplit variable, but only for buffers
"   created with SVNVimDiff.
"
" SVNCommandEdit
"   This variable controls whether the original buffer is replaced ('edit') or
"   split ('split').  If not set, it defaults to 'edit'.
"
" SVNCommandEnableBufferSetup
"   This variable, if set to a non-zero value, activates SVN buffer management
"   mode.  This mode means that two buffer variables, 'SVNRevision' and
"   'SVNBranch', are set if the file is SVN-controlled.  This is useful for
"   displaying version information in the status bar.
"
" SVNCommandInteractive
"   This variable, if set to a non-zero value, causes appropriate functions (for
"   the moment, only SVNReview) to query the user for a revision to use
"   instead of the current revision if none is specified.
"
" SVNCommandNameMarker
"   This variable, if set, configures the special attention-getting characters
"   that appear on either side of the svn buffer type in the buffer name.
"   This has no effect unless 'SVNCommandNameResultBuffers' is set to a true
"   value.  If not set, it defaults to '_'.  
"
" SVNCommandNameResultBuffers
"   This variable, if set to a true value, causes the svn result buffers to be
"   named in the old way ('<source file name> _<svn command>_').  If not set
"   or set to a false value, the result buffer is nameless.
"
" SVNCommandSplit
"   This variable controls the orientation of the various window splits that
"   may occur (such as with SVNVimDiff, when using a SVN command on a SVN
"   command buffer, or when the 'SVNCommandEdit' variable is set to 'split'.
"   If set to 'horizontal', the resulting windows will be on stacked on top of
"   one another.  If set to 'vertical', the resulting windows will be
"   side-by-side.  If not set, it defaults to 'horizontal' for all but
"   SVNVimDiff windows.
"
" SVNCommandAutoSVK
"   This variable is a hack to allow svncommand.vim to work for basic svk
"   operations. It MUST be used in combination with
"   SVNCommandEnableBufferSetup. During buffer setup, the script will stat
"   .svn/entries, and if it doesn't exist, it sets the svn executable name
"   (b:SVNCommandSVNExec) to the value of SVNCommandAutoSVK. This hack works
"   only because of the similarity in commandlines between svn and svk.
"
" Event documentation {{{2
"   For additional customization, svncommand.vim uses User event autocommand
"   hooks.  Each event is in the SVNCommand group, and different patterns
"   match the various hooks.
"
"   For instance, the following could be added to the vimrc to provide a 'q'
"   mapping to quit a SVN buffer:
"
"   augroup SVNCommand
"     au SVNCommand User SVNBufferCreated silent! nmap <unique> <buffer> q:bwipeout<cr> 
"   augroup END
"
"   The following hooks are available:
"
"   SVNBufferCreated           This event is fired just after a svn command
"                              result buffer is created and filled with the
"                              result of a svn command.  It is executed within
"                              the context of the new buffer.
"
"   SVNBufferSetup             This event is fired just after SVN buffer setup
"                              occurs, if enabled.
"
"   SVNPluginInit              This event is fired when the SVNCommand plugin
"                              first loads.
"
"   SVNPluginFinish            This event is fired just after the SVNCommand
"                              plugin loads.
"
"   SVNVimDiffFinish           This event is fired just after the SVNVimDiff
"                              command executes to allow customization of,
"                              for instance, window placement and focus.
"
" Section: Plugin header {{{1
" loaded_svncommand is set to 1 when the initialization begins, and 2 when it
" completes.  This allows various actions to only be taken by functions after
" system initialization.

if exists("loaded_svncommand")
   finish
endif
let loaded_svncommand = 1

" Section: Event group setup {{{1

augroup SVNCommand
augroup END

" Section: Plugin initialization {{{1
silent do SVNCommand User SVNPluginInit


" Section: Utility functions {{{1

" Function: s:SVNResolveLink() {{{2
" Fully resolve the given file name to remove shortcuts or symbolic links.

function! s:SVNResolveLink(fileName)
  let resolved = resolve(a:fileName)
  if resolved != a:fileName
    let resolved = s:SVNResolveLink(resolved)
  endif
  return resolved
endfunction

" Function: s:SVNChangeToCurrentFileDir() {{{2
" Go to the directory in which the current SVN-controlled file is located.
" If this is a SVN command buffer, first switch to the original file.

function! s:SVNChangeToCurrentFileDir(fileName)
  let oldCwd=getcwd()
  let fileName=s:SVNResolveLink(a:fileName)
  let newCwd=fnamemodify(fileName, ':h')
  if strlen(newCwd) > 0
    execute 'cd' escape(newCwd, ' ')
  endif
  return oldCwd
endfunction

" Function: s:SVNGetOption(name, default) {{{2
" Grab a user-specified option to override the default provided.  Options are
" searched in the window, buffer, then global spaces.

function! s:SVNGetOption(name, default)
  if exists("w:" . a:name)
    execute "return w:".a:name
  elseif exists("b:" . a:name)
    execute "return b:".a:name
  elseif exists("g:" . a:name)
    execute "return g:".a:name
  else
    return a:default
  endif
endfunction

" Function: s:SVNEditFile(name, origBuffNR) {{{2
" Wrapper around the 'edit' command to provide some helpful error text if the
" current buffer can't be abandoned.  If name is provided, it is used;
" otherwise, a nameless scratch buffer is used.
" Returns: 0 if successful, -1 if an error occurs.

function! s:SVNEditFile(name, origBuffNR)
  "Name parameter will be pasted into expression.
  let name = escape(a:name, ' *?\')

  let v:errmsg = ""
  let editCommand = s:SVNGetOption('SVNCommandEdit', 'edit')
  if editCommand != 'edit'
    if s:SVNGetOption('SVNCommandSplit', 'horizontal') == 'horizontal'
      if name == ""
        let editCommand = 'rightbelow new'
      else
        let editCommand = 'rightbelow split ' . name
      endif
    else
      if name == ""
        let editCommand = 'vert rightbelow new'
      else
        let editCommand = 'vert rightbelow split ' . name
      endif
    endif
  else
    if name == ""
      let editCommand = 'enew'
    else
      let editCommand = 'edit ' . name
    endif
  endif

  " Protect against useless buffer set-up
  let g:SVNCommandEditFileRunning = 1
  execute editCommand
  unlet g:SVNCommandEditFileRunning

  if v:errmsg != ""
    if &modified && !&hidden
      echoerr "Unable to open command buffer because 'nohidden' is set and the current buffer is modified (see :help 'hidden')."
    else
      echoerr "Unable to open command buffer" v:errmsg
    endif
    return -1
  endif
  let b:SVNOrigBuffNR=a:origBuffNR
  let b:SVNCommandEdit='split'
endfunction

" Function: s:SVNCreateCommandBuffer(cmd, cmdName, statusText, filename) {{{2
" Creates a new scratch buffer and captures the output from execution of the
" given command.  The name of the scratch buffer is returned.

function! s:SVNCreateCommandBuffer(cmd, cmdName, statusText, origBuffNR)
  let fileName=bufname(a:origBuffNR)

  let resultBufferName=''

  if s:SVNGetOption("SVNCommandNameResultBuffers", 0)
    let nameMarker = s:SVNGetOption("SVNCommandNameMarker", '_')
    if strlen(a:statusText) > 0
      let bufName=a:cmdName . ' -- ' . a:statusText
    else
      let bufName=a:cmdName
    endif
    let bufName=fileName . ' ' . nameMarker . bufName . nameMarker
    let counter=0
    let resultBufferName = bufName
    while buflisted(resultBufferName)
      let counter=counter + 1
      let resultBufferName=bufName . ' (' . counter . ')'
    endwhile
  endif

  let svnCommand = s:SVNGetOption("SVNCommandSVNExec", "svn") . " " . a:cmd
  let svnOut = system(svnCommand)
  if strlen(svnOut) == 0
    " Handle case of no output.  In this case, it is important to check the
    " file status, especially since svn edit/unedit may change the attributes
    " of the file with no visible output.

    echomsg "No output from SVN command"
    checktime
    return -1
  endif

  if s:SVNEditFile(resultBufferName, a:origBuffNR) == -1
    return -1
  endif

  set buftype=nofile
  set noswapfile
  set filetype=

  if s:SVNGetOption("SVNCommandDeleteOnHide", 0)
    set bufhidden=delete
  endif

  silent 0put=svnOut

  " The last command left a blank line at the end of the buffer.  If the
  " last line is folded (a side effect of the 'put') then the attempt to
  " remove the blank line will kill the last fold.
  "
  " This could be fixed by explicitly detecting whether the last line is
  " within a fold, but I prefer to simply unfold the result buffer altogether.

  if has('folding')
    normal zR
  endif

  $d
  1

  " Define the environment and execute user-defined hooks.

  let b:SVNSourceFile=fileName
  let b:SVNCommand=a:cmdName
  if a:statusText != ""
    let b:SVNStatusText=a:statusText
  endif

  silent do SVNCommand User SVNBufferCreated
  return bufnr("%")
endfunction

" Function: s:SVNBufferCheck(svnBuffer) {{{2
" Attempts to locate the original file to which SVN operations were applied
" for a given buffer.

function! s:SVNBufferCheck(svnBuffer)
  let origBuffer = getbufvar(a:svnBuffer, "SVNOrigBuffNR")
  if origBuffer
    if bufexists(origBuffer)
      return origBuffer
    else
      " Original buffer no longer exists.
      return -1 
    endif
  else
    " No original buffer
    return a:svnBuffer
  endif
endfunction

" Function: s:SVNCurrentBufferCheck() {{{2
" Attempts to locate the original file to which SVN operations were applied
" for the current buffer.

function! s:SVNCurrentBufferCheck()
  return s:SVNBufferCheck(bufnr("%"))
endfunction

" Function: s:SVNToggleDeleteOnHide() {{{2
" Toggles on and off the delete-on-hide behavior of SVN buffers

function! s:SVNToggleDeleteOnHide()
  if exists("g:SVNCommandDeleteOnHide")
    unlet g:SVNCommandDeleteOnHide
  else
    let g:SVNCommandDeleteOnHide=1
  endif
endfunction

" Function: s:SVNDoCommand(svncmd, cmdName, statusText) {{{2
" General skeleton for SVN function execution.
" Returns: name of the new command buffer containing the command results

function! s:SVNDoCommand(cmd, cmdName, statusText)
  let svnBufferCheck=s:SVNCurrentBufferCheck()
  if svnBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return -1
  endif

  let fileName=bufname(svnBufferCheck)
  let realFileName = fnamemodify(s:SVNResolveLink(fileName), ':t')
  let oldCwd=s:SVNChangeToCurrentFileDir(fileName)
  let fullCmd = a:cmd . ' "' . realFileName . '"'
  let resultBuffer=s:SVNCreateCommandBuffer(fullCmd, a:cmdName, a:statusText, svnBufferCheck)
  execute 'cd' escape(oldCwd, ' ')
  return resultBuffer
endfunction


" Function: s:SVNGetStatusVars(revision, branch, repository) {{{2
"
" Obtains a SVN revision number and branch name.  The 'revisionVar',
" 'branchVar'and 'repositoryVar' arguments, if non-empty, contain the names of variables to hold
" the corresponding results.
"
" Returns: string to be exec'd that sets the multiple return values.

function! s:SVNGetStatusVars(revisionVar, branchVar, repositoryVar)
  let svnBufferCheck=s:SVNCurrentBufferCheck()
  if svnBufferCheck == -1 
    return ""
  endif
  let fileName=bufname(svnBufferCheck)
  let realFileName = fnamemodify(s:SVNResolveLink(fileName), ':t')
  let oldCwd=s:SVNChangeToCurrentFileDir(fileName)

  let svnCommand = s:SVNGetOption("SVNCommandSVNExec", "svn") . " info " . escape(realFileName, ' *?\')
  let statustext=system(svnCommand)
  if(v:shell_error)
    execute 'cd' escape(oldCwd, ' ')
    return ""
  endif
  let revision=substitute(statustext, '^\_.*Revision:\s*\(\d\+\)\_.*', '\1', "")

  " We can still be in a SVN-controlled directory without this being a SVN
  " file
  if match(revision, '^New file!$') >= 0
    let revision="NEW"
  elseif match(revision, '^\d\+$') >=0
  else
    execute 'cd' escape(oldCwd, ' ')
    return ""
  endif

  let returnExpression = "let " . a:revisionVar . "='" . revision . "'"

  if a:repositoryVar != ""
     let repository=substitute(statustext, '^\_.*URL:\s*\([^\s]\+\)\_.*$', '\1', "")
     let returnExpression=returnExpression . " | let " . a:repositoryVar . "='" . repository . "'"
  endif

  execute 'cd' escape(oldCwd, ' ')
  return returnExpression
endfunction

" Function: s:SVNSetupBuffer() {{{2
" Attempts to set the b:SVNBranch, b:SVNRevision and b:SVNRepository variables.

function! s:SVNSetupBuffer()
  if (exists("b:SVNBufferSetup") && b:SVNBufferSetup)
    return
  endif

  if !s:SVNGetOption("SVNCommandEnableBufferSetup", 0)
        \ || @% == ""
        \ || exists("g:SVNCommandEditFileRunning")
        \ || exists("b:SVNOrigBuffNR")
    unlet! b:SVNRevision
    unlet! b:SVNBranch
    unlet! b:SVNRepository
    return
  endif

  if !filereadable(expand("%"))
    return -1
  endif

  " check for SVNCommandAutoSVK to do evil overriding
  if s:SVNGetOption("SVNCommandAutoSVK", 'unset') != 'unset'
    " The first thing we do is check for a .svn file, if it's not there, then
    " we go into svk mode MUAHAHAHAHA
    if !filereadable('.svn/entries')
      let b:SVNCommandSVNExec = s:SVNGetOption("SVNCommandAutoSVK", 'svk')
    endif
  endif

  let revision=""
  let branch=""
  let repository=""

  exec s:SVNGetStatusVars('revision', 'branch', 'repository')
  if revision != ""
    let b:SVNRevision=revision
  else
    unlet! b:SVNRevision
  endif
  if branch != ""
    let b:SVNBranch=branch
  else
    unlet! b:SVNBranch
  endif
  if repository != ""
     let b:SVNRepository=repository
  else
     unlet! b:SVNRepository
  endif
  silent do SVNCommand User SVNBufferSetup
  let b:SVNBufferSetup=1
endfunction

" Function: s:SVNMarkOrigBufferForSetup(svnbuffer) {{{2
" Resets the buffer setup state of the original buffer for a given SVN buffer.
" Returns:  The SVN buffer number in a passthrough mode.

function! s:SVNMarkOrigBufferForSetup(svnBuffer)
  if a:svnBuffer != -1
    let origBuffer = s:SVNBufferCheck(a:svnBuffer)
    "This should never not work, but I'm paranoid
    if origBuffer != a:svnBuffer
      call setbufvar(origBuffer, "SVNBufferSetup", 0)
    endif
  endif
  return a:svnBuffer
endfunction

" Section: Public functions {{{1

" Function: SVNGetRevision() {{{2
" Global function for retrieving the current buffer's SVN revision number.
" Returns: Revision number or an empty string if an error occurs.

function! SVNGetRevision()
  let revision=""
  exec s:SVNGetStatusVars('revision', '', '')
  return revision
endfunction

" Function: SVNDisableBufferSetup() {{{2
" Global function for deactivating the buffer autovariables.

function! SVNDisableBufferSetup()
  let g:SVNCommandEnableBufferSetup=0
  silent! augroup! SVNCommandPlugin
endfunction

" Function: SVNEnableBufferSetup() {{{2
" Global function for activating the buffer autovariables.

function! SVNEnableBufferSetup()
  let g:SVNCommandEnableBufferSetup=1
  augroup SVNCommandPlugin
    au!
    au BufEnter * call s:SVNSetupBuffer()
  augroup END

  " Only auto-load if the plugin is fully loaded.  This gives other plugins a
  " chance to run.
  if g:loaded_svncommand == 2
    call s:SVNSetupBuffer()
  endif
endfunction

" Function: SVNGetStatusLine() {{{2
" Default (sample) status line entry for SVN files.  This is only useful if
" SVN-managed buffer mode is on (see the SVNCommandEnableBufferSetup variable
" for how to do this).

function! SVNGetStatusLine()
  if exists('b:SVNSourceFile')
    " This is a result buffer
    let value='[' . b:SVNCommand . ' ' . b:SVNSourceFile
    if exists('b:SVNStatusText')
      let value=value . ' ' . b:SVNStatusText
    endif
    let value = value . ']'
    return value
  endif

  if exists('b:SVNRevision')
        \ && b:SVNRevision != ''
        \ && exists('b:SVNRepository')
        \ && b:SVNRepository != ''
        \ && exists('g:SVNCommandEnableBufferSetup')
        \ && g:SVNCommandEnableBufferSetup
    return '[SVN ' . b:SVNRevision . '|' . b:SVNRepository . ']'
  else
    return ''
  endif
endfunction

" Section: SVN command functions {{{1

" Function: s:SVNAdd() {{{2
function! s:SVNAdd()
  return s:SVNMarkOrigBufferForSetup(s:SVNDoCommand('add', 'svnadd', ''))
endfunction

" Function: s:SVNAnnotate(...) {{{2
function! s:SVNAnnotate(...)
  let svnBufferCheck=s:SVNCurrentBufferCheck()
  if svnBufferCheck == -1 
    echo "Original buffer no longer exists, aborting."
    return -1
  endif

  let fileName=bufname(svnBufferCheck)
  let realFileName = fnamemodify(s:SVNResolveLink(fileName), ':t')
  let oldCwd=s:SVNChangeToCurrentFileDir(fileName)

  let currentLine=line(".")

  if a:0 == 0
    " we already are in a SVN Annotate buffer
    if &filetype == "SVNAnnotate"
      let revision = substitute(getline("."),'\(^[0-9.]*\).*','\1','')
      let revmin = substitute(revision,'^[0-9.]*\.\([0-9]\+\)','\1','') + 0 -1 
      let revmaj = substitute(revision,'^\([0-9.]*\)\.[0-9]\+','\1','')
      if revmin == 0
        " Jump to ancestor branch
        let revision = substitute(revmaj,'^\([0-9.]*\)\.[0-9]\+','\1','')
      else
        let revision=revmaj . "." .  revmin
      endif
    else
      let revision=SVNGetRevision()
      if revision == ""
        echo "Unable to obtain status for " . fileName
        execute 'cd' escape(oldCwd, ' ')
        return -1
      endif
    endif
  else
    let revision=a:1
  endif

  if revision == "NEW"
    echo "No annotatation available for new file " . fileName
    execute 'cd' escape(oldCwd, ' ')
    return -1
  endif

  let resultBuffer=s:SVNCreateCommandBuffer('annotate -r ' . revision . ' "' . realFileName . '"', 'svnannotate', revision, svnBufferCheck) 
  if resultBuffer !=  -1
    exec currentLine
    set filetype=SVNAnnotate
  endif

  execute 'cd' escape(oldCwd, ' ')
  return resultBuffer
endfunction

" Function: s:SVNCommit() {{{2
function! s:SVNCommit()
  let svnBufferCheck=s:SVNCurrentBufferCheck()
  if svnBufferCheck ==  -1
    echo "Original buffer no longer exists, aborting."
    return -1
  endif

  " Protect against windows' backslashes in paths.  They confuse exec'd
  " commands.

  let shellSlashBak = &shellslash
  set shellslash

  let messageFileName = tempname()

  let fileName=bufname(svnBufferCheck)
  let realFilePath=s:SVNResolveLink(fileName)
  let newCwd=fnamemodify(realFilePath, ':h')
  let realFileName=fnamemodify(realFilePath, ':t')

  if s:SVNEditFile(messageFileName, svnBufferCheck) == -1
    let &shellslash = shellSlashBak
    return
  endif

  " Protect against case and backslash issues in Windows.
  let autoPattern = '\c' . messageFileName

  " Ensure existance of group
  augroup SVNCommit
  augroup END

  execute 'au SVNCommit BufDelete' autoPattern 'call delete("' . messageFileName . '")'
  execute 'au SVNCommit BufDelete' autoPattern 'au! SVNCommit * ' autoPattern

  " Create a commit mapping.  The mapping must clear all autocommands in case
  " it is invoked when SVNCommandCommitOnWrite is active, as well as to not
  " invoke the buffer deletion autocommand.

  execute 'nnoremap <silent> <buffer> <Plug>SVNCommit '.
        \ ':au! SVNCommit * ' . autoPattern . '<CR>'.
        \ ':update<CR>'.
        \ ':call <SID>SVNFinishCommit("' . messageFileName . '",' .
        \                             '"' . newCwd . '",' .
        \                             '"' . realFileName . '",' .
        \                             svnBufferCheck . ')<CR>'

  silent put='--This line, and those below, will be ignored--'

  let svnCommand = s:SVNGetOption("SVNCommandSVNExec", "svn") . " status " . escape(realFileName, ' *?\')
  let statustext=system(svnCommand)

  silent put=statustext

  if s:SVNGetOption('SVNCommandCommitOnWrite', 1) == 1
    execute 'au SVNCommit BufWritePost' autoPattern 'call s:SVNFinishCommit("' . messageFileName . '", "' . newCwd . '", "' . realFileName . '", ' . svnBufferCheck . ') | au! * ' autoPattern
  endif

  0
  let b:SVNSourceFile=fileName
  let b:SVNCommand='SVNCommit'
  set filetype=svn
  let &shellslash = shellSlashBak
endfunction

" Function: s:SVNDiff(...) {{{2
function! s:SVNDiff(...)
  if a:0 == 1
    let revOptions = '-r' . a:1
    let caption = a:1 . ' -> current'
  elseif a:0 == 2
    let revOptions = '-r' . a:1 . ':' . a:2
    let caption = a:1 . ' -> ' . a:2
  else
    let revOptions = ''
    let caption = ''
  endif

  let svndiffopt=s:SVNGetOption('SVNCommandDiffOpt', '')

  if svndiffopt == ""
    let diffoptionstring=""
  else
    let diffoptionstring=" -" . svndiffopt . " "
  endif

  let resultBuffer = s:SVNDoCommand('diff ' . diffoptionstring . revOptions , 'svndiff', caption)
  if resultBuffer != -1 
    set filetype=diff
  endif
  return resultBuffer
endfunction

" Function: s:SVNGotoOriginal(["!]) {{{2
function! s:SVNGotoOriginal(...)
  let origBuffNR = s:SVNCurrentBufferCheck()
  if origBuffNR > 0
    execute 'buffer' origBuffNR
    if a:0 == 1
      if a:1 == "!"
        let buffnr = 1
        let buffmaxnr = bufnr("$")
        while buffnr <= buffmaxnr
          if getbufvar(buffnr, "SVNOrigBuffNR") == origBuffNR
            execute "bw" buffnr
          endif
          let buffnr = buffnr + 1
        endwhile
      endif
    endif
  endif
endfunction

" Function: s:SVNFinishCommit(messageFile, targetDir, targetFile) {{{2
function! s:SVNFinishCommit(messageFile, targetDir, targetFile, origBuffNR)
  if filereadable(a:messageFile)
    let oldCwd=getcwd()
    if strlen(a:targetDir) > 0
      execute 'cd' escape(a:targetDir, ' ')
    endif
    let resultBuffer=s:SVNCreateCommandBuffer('commit -F "' . a:messageFile . '" "'. a:targetFile . '"', 'svncommit', '', a:origBuffNR)
    execute 'cd' escape(oldCwd, ' ')
    execute 'bw' escape(a:messageFile, ' *?\')
    silent execute 'call delete("' . a:messageFile . '")'
    return s:SVNMarkOrigBufferForSetup(resultBuffer)
  else
    echoerr "Can't read message file; no commit is possible."
    return -1
  endif
endfunction

" Function: s:SVNLog() {{{2
function! s:SVNLog(...)
  if a:0 == 0
    let versionOption = ""
    let caption = ''
  else
    let versionOption=" -r" . a:1
    let caption = a:1
  endif

  let resultBuffer=s:SVNDoCommand('log -v' . versionOption, 'svnlog', caption)
  if resultBuffer != ""
    set filetype=svnlog
  endif
  return resultBuffer
endfunction

" Function: s:SVNRevert() {{{2
function! s:SVNRevert()
  return s:SVNMarkOrigBufferForSetup(s:SVNDoCommand('revert', 'svnrevert', ''))
endfunction

" Function: s:SVNReview(...) {{{2
function! s:SVNReview(...)
  if a:0 == 0
    let versiontag=""
    if s:SVNGetOption('SVNCommandInteractive', 0)
      let versiontag=input('Revision:  ')
    endif
    if versiontag == ""
      let versiontag="(current)"
      let versionOption=""
    else
      let versionOption=" -r " . versiontag . " "
    endif
  else
    let versiontag=a:1
    let versionOption=" -r " . versiontag . " "
  endif

  let resultBuffer = s:SVNDoCommand('cat ' . versionOption, 'svnreview', versiontag)
  if resultBuffer > 0
    let &filetype=getbufvar(b:SVNOrigBuffNR, '&filetype')
  endif

  return resultBuffer
endfunction

" Function: s:SVNStatus() {{{2
function! s:SVNStatus()
  return s:SVNDoCommand('status -v', 'svnstatus', '')
endfunction

" Function: s:SVNInfo() {{{2
function! s:SVNInfo()
  return s:SVNDoCommand('info', 'svninfo', '')
endfunction

" Function: s:SVNUpdate() {{{2
function! s:SVNUpdate()
  return s:SVNMarkOrigBufferForSetup(s:SVNDoCommand('update', 'update', ''))
endfunction

" Function: s:SVNVimDiff(...) {{{2
function! s:SVNVimDiff(...)
  if(a:0 == 2)
    let resultBuffer = s:SVNReview(a:1)
    if resultBuffer < 0
      echomsg "Can't open SVN revision " . a:1
      return resultBuffer
    endif
    diffthis
    " If no split method is defined, cheat, and set it to vertical.
    if s:SVNGetOption('SVNCommandDiffSplit', s:SVNGetOption('SVNCommandSplit', 'dummy')) == 'dummy'
      let b:SVNCommandSplit='vertical'
    endif
    let resultBuffer=s:SVNReview(a:2)
    if resultBuffer < 0
      echomsg "Can't open SVN revision " . a:1
      return resultBuffer
    endif
    diffthis
  else
    if(a:0 == 0)
      let resultBuffer=s:SVNReview()
      if resultBuffer < 0
        echomsg "Can't open current SVN revision"
        return resultBuffer
      endif
      diffthis
    else
      let resultBuffer=s:SVNReview(a:1)
      if resultBuffer < 0
        echomsg "Can't open SVN revision " . a:1
        return resultBuffer
      endif
      diffthis
    endif
    let originalBuffer=b:SVNOrigBuffNR
    let originalWindow=bufwinnr(originalBuffer)

    " Don't remove the just-created buffer
    let savedHideOption = getbufvar(resultBuffer, '&bufhidden')
    call setbufvar(resultBuffer, '&bufhidden', 'hide')

    execute "hide b" originalBuffer

    " If there's already a VimDiff'ed window, restore it.
    " There may only be one SVNVimDiff original window at a time.

    if exists("g:SVNCommandRestoreVimDiffStateCmd")
      execute g:SVNCommandRestoreVimDiffStateCmd
    endif

    " Store the state of original buffer so that it can reset when the SVN
    " buffer departs.

    let g:SVNCommandRestoreVimDiffSourceBuffer = originalBuffer
    let g:SVNCommandRestoreVimDiffScratchBuffer = resultBuffer
    let g:SVNCommandRestoreVimDiffStateCmd = 
          \    "call setbufvar(".originalBuffer.", \"&diff\", ".getwinvar(originalWindow, '&diff').")"
          \ . "|call setbufvar(".originalBuffer.", \"&foldcolumn\", ".getwinvar(originalWindow, '&foldcolumn').")"
          \ . "|call setbufvar(".originalBuffer.", \"&foldenable\", ".getwinvar(originalWindow, '&foldenable').")"
          \ . "|call setbufvar(".originalBuffer.", \"&foldmethod\", '". getwinvar(originalWindow, '&foldmethod')."')"
          \ . "|call setbufvar(".originalBuffer.", \"&scrollbind\", ".getwinvar(originalWindow, '&scrollbind').")"
          \ . "|call setbufvar(".originalBuffer.", \"&wrap\", ".getwinvar(originalWindow, '&wrap').")"

    if getwinvar(originalWindow, "&foldmethod") == 'manual'
        let g:SVNCommandRestoreVimDiffStateCmd = g:SVNCommandRestoreVimDiffStateCmd
            \ . "|normal zE"
    endif

    diffthis

    let g:SVNCommandEditFileRunning = 1
    if s:SVNGetOption('SVNCommandDiffSplit', s:SVNGetOption('SVNCommandSplit', 'vertical')) == 'horizontal'
      execute "silent rightbelow sbuffer" . resultBuffer
    else
      execute "silent vert rightbelow sbuffer" . resultBuffer
    endif
    unlet g:SVNCommandEditFileRunning

    " Protect against VIM's splitting rules as they impact scrollbind
    call setbufvar(originalBuffer, '&scrollbind', 1)
    call setbufvar(resultBuffer, '&scrollbind', 1)

    call setbufvar(resultBuffer, '&bufhidden', savedHideOption)
  endif

  silent do SVNCommand User SVNVimDiffFinish
  return resultBuffer
endfunction

" Function: s:SVNCommitDiff() {{{2
function! s:SVNCommitDiff()
  let i = line('$')       " last line #
  let cmdline = ""

  let myline = getline(i)
  while i >= 0 && myline =~ "[DMA_][M ]   .*"
    " rip off the filename and prepend to cmdline
    let cmdline = strpart(myline, 5) . " " . cmdline

    " prepare for the next iteration
    let i = i - 1
    let myline = getline(i)
  endwhile

  if cmdline == ''
    echoerr "No well formed lines found"
    return
  endif

  let resultBuffer = s:SVNDoCommand('diff ' . cmdline, 'svndiff', '')
  if resultBuffer != -1
    set filetype=diff
  endif
  return resultBuffer

endfunction

" Section: Command definitions {{{1
" Section: Primary commands {{{2
com! SVNAdd call s:SVNAdd()
com! -nargs=? SVNAnnotate call s:SVNAnnotate(<f-args>)
com! SVNCommit call s:SVNCommit()
com! -nargs=* SVNDiff call s:SVNDiff(<f-args>)
com! -bang SVNGotoOriginal call s:SVNGotoOriginal(<q-bang>)
com! -nargs=? SVNLog call s:SVNLog(<f-args>)
com! SVNRevert call s:SVNRevert()
com! -nargs=? SVNReview call s:SVNReview(<f-args>)
com! SVNStatus call s:SVNStatus()
com! SVNInfo call s:SVNInfo()
com! SVNUpdate call s:SVNUpdate()
com! -nargs=* SVNVimDiff call s:SVNVimDiff(<f-args>)
com! SVNCommitDiff call s:SVNCommitDiff()

" Section: SVN buffer management commands {{{2
com! SVNDisableBufferSetup call SVNDisableBufferSetup()
com! SVNEnableBufferSetup call SVNEnableBufferSetup()

" Allow reloading svncommand.vim
com! SVNReload unlet! loaded_svncommand | runtime plugin/svncommand.vim

" Section: Plugin command mappings {{{1
nnoremap <silent> <Plug>SVNAdd :SVNAdd<CR>
nnoremap <silent> <Plug>SVNAnnotate :SVNAnnotate<CR>
nnoremap <silent> <Plug>SVNCommit :SVNCommit<CR>
nnoremap <silent> <Plug>SVNDiff :SVNDiff<CR>
nnoremap <silent> <Plug>SVNGotoOriginal :SVNGotoOriginal<CR>
nnoremap <silent> <Plug>SVNClearAndGotoOriginal :SVNGotoOriginal!<CR>
nnoremap <silent> <Plug>SVNLog :SVNLog<CR>
nnoremap <silent> <Plug>SVNRevert :SVNRevert<CR>
nnoremap <silent> <Plug>SVNReview :SVNReview<CR>
nnoremap <silent> <Plug>SVNStatus :SVNStatus<CR>
nnoremap <silent> <Plug>SVNInfo :SVNInfo<CR>
nnoremap <silent> <Plug>SVNUnedit :SVNUnedit<CR>
nnoremap <silent> <Plug>SVNUpdate :SVNUpdate<CR>
nnoremap <silent> <Plug>SVNVimDiff :SVNVimDiff<CR>
nnoremap <silent> <Plug>SVNCommitDiff :SVNCommitDiff<CR>

" Section: Default mappings {{{1
if !hasmapto('<Plug>SVNAdd')
  nmap <unique> <Leader>sa <Plug>SVNAdd
endif
if !hasmapto('<Plug>SVNAnnotate')
  nmap <unique> <Leader>sn <Plug>SVNAnnotate
endif
if !hasmapto('<Plug>SVNClearAndGotoOriginal')
  nmap <unique> <Leader>sG <Plug>SVNClearAndGotoOriginal
endif
if !hasmapto('<Plug>SVNCommit')
  nmap <unique> <Leader>sc <Plug>SVNCommit
endif
if !hasmapto('<Plug>SVNDiff')
  nmap <unique> <Leader>sd <Plug>SVNDiff
endif
if !hasmapto('<Plug>SVNGotoOriginal')
  nmap <unique> <Leader>sg <Plug>SVNGotoOriginal
endif
if !hasmapto('<Plug>SVNLog')
  nmap <unique> <Leader>sl <Plug>SVNLog
endif
if !hasmapto('<Plug>SVNRevert')
  nmap <unique> <Leader>sq <Plug>SVNRevert
endif
if !hasmapto('<Plug>SVNReview')
  nmap <unique> <Leader>sr <Plug>SVNReview
endif
if !hasmapto('<Plug>SVNStatus')
  nmap <unique> <Leader>ss <Plug>SVNStatus
endif
if !hasmapto('<Plug>SVNInfo')
  nmap <unique> <Leader>si <Plug>SVNInfo
endif
if !hasmapto('<Plug>SVNUpdate')
  nmap <unique> <Leader>su <Plug>SVNUpdate
endif
if !hasmapto('<Plug>SVNVimDiff')
  nmap <unique> <Leader>sv <Plug>SVNVimDiff
endif

" Section: Menu items {{{1
silent! aunmenu Plugin.SVN
amenu <silent> &Plugin.SVN.&Add        <Plug>SVNAdd
amenu <silent> &Plugin.SVN.A&nnotate   <Plug>SVNAnnotate
amenu <silent> &Plugin.SVN.&Commit     <Plug>SVNCommit
amenu <silent> &Plugin.SVN.&Diff       <Plug>SVNDiff
amenu <silent> &Plugin.SVN.&Log        <Plug>SVNLog
amenu <silent> &Plugin.SVN.Revert      <Plug>SVNRevert
amenu <silent> &Plugin.SVN.&Review     <Plug>SVNReview
amenu <silent> &Plugin.SVN.&Status     <Plug>SVNStatus
amenu <silent> &Plugin.SVN.&Info       <Plug>SVNInfo
amenu <silent> &Plugin.SVN.&Update     <Plug>SVNUpdate
amenu <silent> &Plugin.SVN.&VimDiff    <Plug>SVNVimDiff

" Section: Autocommands to restore vimdiff state {{{1
function! s:SVNVimDiffRestore(vimDiffBuff)
  if exists("g:SVNCommandRestoreVimDiffScratchBuffer")
        \ && a:vimDiffBuff == g:SVNCommandRestoreVimDiffScratchBuffer
    if exists("g:SVNCommandRestoreVimDiffSourceBuffer")
      " Only restore if the source buffer is still in Diff mode
      if getbufvar(g:SVNCommandRestoreVimDiffSourceBuffer, "&diff")
        if exists("g:SVNCommandRestoreVimDiffStateCmd")
          execute g:SVNCommandRestoreVimDiffStateCmd
          unlet g:SVNCommandRestoreVimDiffStateCmd
        endif
      endif
      unlet g:SVNCommandRestoreVimDiffSourceBuffer
    endif
    unlet g:SVNCommandRestoreVimDiffScratchBuffer
  endif
endfunction

augroup SVNVimDiffRestore
  au!
  au BufUnload * call s:SVNVimDiffRestore(expand("<abuf>"))
augroup END

" Section: Optional activation of buffer management {{{1

if s:SVNGetOption('SVNCommandEnableBufferSetup', 0)
  call SVNEnableBufferSetup()
endif

" Section: Plugin completion {{{1

let loaded_svncommand=2
silent do SVNCommand User SVNPluginFinish
