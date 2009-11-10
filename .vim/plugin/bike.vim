" Bicycle Repair Man integration for Vim
" Version 0.3
" Copyright (c) 2003 Marius Gedminas <mgedmin@delfi.lt>
"
" Needs Vim 6.x with python interpreter (Python 2.2 or newer)
" Installation instructions: just drop it into $HOME/.vim/plugin and you
" should see the Bicycle Repair Menu appear in GVim (or you can check if
" any of the BikeXxx commands are defined in console mode Vim).  If bike.vim
" fails to load and you want to see the reason, try
"   let g:bike_exceptions = 1
"   source ~/.vim/plugin/bike.vim
"
" Configuration options you can add to your .vimrc:
"   let g:bike_exceptions = 1           " show tracebacks on exceptions
"   let g:bike_progress = 1             " show import progress
"
" Commands defined:
"
"   BikeShowScope
"       Show current scope.  Sample of usage:
"         autocmd CursorHold *.py BikeShowScope
"
"   <range> BikeShowType
"       Show selected expression type.  The range is ignored, '<,'> is always
"       used.  Use this in visual block mode.
"
"   BikeFindRefs
"       Finds all references of the function/method/class defined in current
"       line.
"
"   BikeFindDef
"       Finds the definition of the function/method/class under cursor.
"
"   BikeRename
"       Renames the function/method/class defined in current line.  Updates
"       all references in all files known (i.e. imported) to Bicycle Repair
"       Man.
"
"   <range> BikeExtract
"       Extracts a part of the function/method into a new function/method.
"       The range is ignored, '<,'> is always used.  Use this in visual mode.
"
"   BikeUndo
"       Globally undoes the previous refactoring.
"
" Issues:
"  - Saves all modified buffers to disk without asking the user -- not nice
"  - Does not reimport files that were modified outside of Vim
"  - Uses mktemp() -- I think that produces deprecation warnings in Python 2.3
"  - BikeShowType, BikeExtract ignores the specified range, that's confusing.
"    At least BikeExtract ought to work...
"  - BikeShowType/BikeExtract or their GUI counterparts work when not in
"    visual mode by using the previous values of '<,'>.  Might be confusing.
"  - Would be nice if :BikeImport<CR> asked to enter package
"  - Would be nice if :BikeRename myNewName<CR> worked
"  - The code is not very robust (grep for XXX)

"
" Default settings for global configuration variables                   {{{1
"

" Set to 1 to see full tracebacks
if !exists("g:bike_exceptions")
    let g:bike_exceptions = 0
endif

" Set to 1 to see import progress
if !exists("g:bike_progress")
    let g:bike_progress = 0
endif

"
" Initialization                                                        {{{1
"

" First check that Vim is sufficiently recent, that we have python interpreted
" support, and that Bicycle Repair Man is available.
"
" If something is wrong, fail silently, as error messages every time vim
" starts are very annoying.  But if the user wants to see why bike.vim failed
" to load, she can let g:bike_exceptions = 1
if version < 600
    if g:bike_exceptions
        echo 'Bicycle Repair Man needs Vim 6.0'
    endif
    finish
endif

if !has("python")
    if g:bike_exceptions
        echo 'Bicycle Repair Man needs Vim with Python interpreter support (2.2 or newer)'
    endif
    finish
endif

let s:has_bike=1
python << END
import vim
import sys
try:
    if sys.version_info < (2, 2):
        raise ImportError, 'Bicycle Repair Man needs Python 2.2 or newer'
    import bike
    bikectx = bike.init()
    bikectx.isLoaded        # make sure bike package is recent enough
except ImportError:
    vim.command("let s:has_bike=0")
    if vim.eval('g:bike_exceptions') not in (None, '', '0'):
        raise
END
if !s:has_bike
    finish
endif

" Use sane cpoptions
let s:cpo_save = &cpo
set cpo&vim

"
" Menu                                                                  {{{1
"
silent! aunmenu Bicycle\ Repair\ Man

" Shortcuts available: ab-----h-jk--nopq----vw--z
amenu <silent> Bicycle\ &Repair\ Man.-SEP1-
\       :
amenu <silent> Bicycle\ &Repair\ Man.&Find\ References
\       :call <SID>BikeFindRefs()<CR>
amenu <silent> Bicycle\ &Repair\ Man.Find\ &Definition
\       :call <SID>BikeFindDef()<CR>
amenu <silent> Bicycle\ &Repair\ Man.Resu&lts.&List<tab>:cl
\       :cl<CR>
amenu <silent> Bicycle\ &Repair\ Man.Resu&lts.&Current<tab>:cc
\       :cc<CR>
amenu <silent> Bicycle\ &Repair\ Man.Resu&lts.&Next<tab>:cn
\       :cn<CR>
amenu <silent> Bicycle\ &Repair\ Man.Resu&lts.&Previous<tab>:cp
\       :cp<CR>
amenu <silent> Bicycle\ &Repair\ Man.Resu&lts.&First<tab>:cfirst
\       :cfirst<CR>
amenu <silent> Bicycle\ &Repair\ Man.Resu&lts.Las&t<tab>:clast
\       :clast<CR>
amenu <silent> Bicycle\ &Repair\ Man.Resu&lts.&Older\ List<tab>:colder
\       :colder<CR>
amenu <silent> Bicycle\ &Repair\ Man.Resu&lts.N&ewer\ List<tab>:cnewer
\       :cnewer<CR>
amenu <silent> Bicycle\ &Repair\ Man.Resu&lts.&Window.&Update<tab>:cw
\       :cw<CR>
amenu <silent> Bicycle\ &Repair\ Man.Resu&lts.&Window.&Open<tab>:copen
\       :copen<CR>
amenu <silent> Bicycle\ &Repair\ Man.Resu&lts.&Window.&Close<tab>:cclose
\       :cclose<CR>
amenu <silent> Bicycle\ &Repair\ Man.-SEP2-
\       :
amenu <silent> Bicycle\ &Repair\ Man.&Rename
\       :call <SID>BikeRename()<CR>
amenu <silent> Bicycle\ &Repair\ Man.E&xtract\ Method
\       :call <SID>BikeExtract('method')<CR>
amenu <silent> Bicycle\ &Repair\ Man.&Extract\ Function
\       :call <SID>BikeExtract('function')<CR>
amenu <silent> Bicycle\ &Repair\ Man.&Undo
\       :call <SID>BikeUndo()<CR>
amenu <silent> Bicycle\ &Repair\ Man.-SEP3-
\       :
amenu <silent> Bicycle\ &Repair\ Man.Settin&gs.Import\ &Progress.&Enable
\       :let g:bike_progress = 1<CR>
amenu <silent> Bicycle\ &Repair\ Man.Settin&gs.Import\ &Progress.&Disable
\       :let g:bike_progress = 0<CR>
amenu <silent> Bicycle\ &Repair\ Man.Settin&gs.Full\ &Exceptions.&Enable
\       :let g:bike_exceptions = 1<CR>
amenu <silent> Bicycle\ &Repair\ Man.Settin&gs.Full\ &Exceptions.&Disable
\       :let g:bike_exceptions = 0<CR>

" Note: The three rename commands are basically identical.  The two extract
" commands are also identical behind the scenes.

"
" Commands                                                              {{{1
"

command! BikeShowScope          call <SID>BikeShowScope()
command! -range BikeShowType    call <SID>BikeShowType()
command! BikeFindRefs           call <SID>BikeFindRefs()
command! BikeFindDef            call <SID>BikeFindDef()

command! BikeRename             call <SID>BikeRename()
command! -range BikeExtract     call <SID>BikeExtract('function')
command! BikeUndo               call <SID>BikeUndo()

"
" Implementation                                                        {{{1
"

" Query functions                                                       {{{2

function! s:BikeShowScope()
" Shows the scope under cursor
    python << END
fn = vim.current.buffer.name
row, col = vim.current.window.cursor
try:
    print bikectx.getFullyQualifiedNameOfScope(fn, row)
except:
    show_exc()
END
endf

function! s:BikeShowType()
" Shows the inferred type of the selected expression
    if col("'<") == 0            " mark not set
        echo "Select a region first!"
        return
    endif
    if line("'<") != line("'>")  " multiline selection
        echo "Multi-line regions not supported"
        " XXX deficiency of bikefacade interface, expressions can easily span
        " several lines in Python
        return
    endif
    python << END
fn = vim.current.buffer.name
row1, col1 = vim.current.buffer.mark('<')
row2, col2 = vim.current.buffer.mark('>')
try:
    print bikectx.getTypeOfExpression(fn, row1, col1, col2)
except:
    show_exc()
END
endf

function! s:BikeFindRefs()
" Find all references to the item defined on current line
    wall
    python << END
fn = vim.current.buffer.name
row, col = vim.current.window.cursor
try:
    refs = bikectx.findReferencesByCoordinates(fn, row, col)
    quickfixdefs(refs)
except:
    show_exc()
END
endf

function! s:BikeFindDef()
" Find all definitions of the item under cursor.  Ideally there should be only
" one.
    wall
    python << END
fn = vim.current.buffer.name
row, col = vim.current.window.cursor
try:
    defs = bikectx.findDefinitionByCoordinates(fn, row, col)
    quickfixdefs(defs)
except:
    show_exc()
END
endf

" Refactoring commands                                                  {{{2

function! s:BikeRename()
" Rename a function/method/class.

    let newname = inputdialog('Rename to: ')
    wall
    python << END
fn = vim.current.buffer.name
row, col = vim.current.window.cursor
newname = vim.eval("newname")
if newname:
    try:
        bikectx.setRenameMethodPromptCallback(renameMethodPromptCallback)
        bikectx.renameByCoordinates(fn, row, col, newname)
    except:
        show_exc()
    saveChanges()
else:
    print "Aborted"
END
endf

function! s:BikeExtract(what)
" Extract a piece of code into a separate function/method.  The argument
" a:what can be 'method' or 'function'.
    if col("'<") == 0            " mark not set
        echo "Select a region first!"
        return
    endif
    let newname = inputdialog('New function name: ')
    wall
    python << END
fn = vim.current.buffer.name
row1, col1 = vim.current.buffer.mark('<')
row2, col2 = vim.current.buffer.mark('>')
newname = vim.eval("newname")
if newname:
    try:
		bikectx.extractMethod(fn, row1, col1, row2, col2, newname)
    except:
        show_exc()
    saveChanges()
else:
    print "Aborted"
END
endf

function! s:BikeUndo()
" Undoes the last refactoring
    wall
python << END
try:
    bikectx.undo()
    saveChanges()
except bike.UndoStackEmptyException, e:
    print "Nothing to undo"
END
endf

"
" Helper functions                                                      {{{1
"

" Python helpers

python << END

import tempfile
import os
import linecache

modified = {}   # a dictionary whose keys are the names of files modifed
                # in Vim since the last import

def show_exc():
    """Print exception according to bike settings."""
    if vim.eval('g:bike_exceptions') not in (None, '', '0'):
        import traceback
        traceback.print_exc()
    else:
        type, value = sys.exc_info()[:2]
        if value is not None:
            print "%s: %s" % (type, value)
        else:
            print type

def writedefs(defs, filename):
    """Write a list of file locations to a file."""
    ef = None
    curdir = os.getcwd()
    if not curdir.endswith(os.sep):
        curdir = curdir + os.sep
    for d in defs:
        if not ef:
            ef = open(filename, "w")
        fn = d.filename
        if fn.startswith(curdir):
            fn = fn[len(curdir):]
        line = linecache.getline(fn, d.lineno).strip()
        res ="%s:%d: %3d%%: %s" % (fn, d.lineno, d.confidence, line)
        print res
        print >> ef, res
    if ef:
        ef.close()
    return ef is not None

def quickfixdefs(defs):
    """Import a list of file locations into vim error list."""
    fn = tempfile.mktemp()      # XXX unsafe
    if writedefs(defs, fn):
        vim.command('let old_errorfile = &errorfile')
        vim.command('let old_errorformat = &errorformat')
        vim.command(r'set errorformat=\%f:\%l:\ \%m')
        vim.command("cfile %s" % fn)
        vim.command('let &errorformat = old_errorformat')
        vim.command('let &errorfile = old_errorfile')
        os.unlink(fn)
    else:
        print "Not found"

def renameMethodPromptCallback(filename, line, col1, col2):
    """Verify that the call in a given file position should be renamed."""
    vim.command('e +%d %s' % (line, filename))
    vim.command('normal %d|' % col1)
    vim.command('match Search /\%%%dl\%%>%dc\%%<%dc' % (line, col1, col2+1))
    vim.command('redraw')
    ans = vim.eval('confirm("Cannot deduce instance type.  Rename this call?",'
                   ' "&Yes\n&No", 1, "Question")')
    vim.command('match none')
    if ans == '1':
        return 1
    else:
        return 0


def saveChanges():
    """Save refactoring changes to the file system and reload the modified
    files in Vim."""
    # bikectx.save() returns a list of modified file names.  We should make
    # sure that all those files are reloaded iff they were open in vim.
    files = map(os.path.abspath, bikectx.save())

    opened_files = {}
    for b in vim.buffers:
        if b.name is not None:
            opened_files[os.path.abspath(b.name)] = b.name

    for f in files:
        try:
            # XXX might fail when file name contains funny characters
            vim.command("sp %s | q" % opened_files[f])
        except KeyError:
            pass

    # Just in case:
    vim.command("checktime")
    vim.command("e")

END

" Make sure modified files are reimported into BRM
autocmd BufWrite * python modified[os.path.abspath(vim.current.buffer.name)] = 1

"
" Cleanup                                                               {{{1
"

" Restore cpoptions
let &cpo = s:cpo_save
unlet s:cpo_save
