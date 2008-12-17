" Vim syntax file
" Language:     Kid
" Maintainer:   Karl Guertin <grayrest@gr.ayre.st>
" Last Change:  Wed Feb 15, 2006
" Filenames:    *.kid
"
" This syntax file covers the Kid template attribute language.
"
" Known bug:
"  Double quotes inside a kid attributes are broken, even when quoted. Too
"  many levels of quoting and nesting and whatnot. I think the html layer is
"  to blame but it's hard to tell.

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
    finish
endif

runtime syntax/xhtml.vim
unlet b:current_syntax
let python_highlight_builtins = 1
syn include @pythonCode syntax/python.vim
syn case match

syn keyword kidFunctions XML defined value_of contained

syn clear pythonString
syn region pythonString		matchgroup=Normal start=+[uU]\='+ end=+'+ skip=+\\\\\|\\'+ contains=pythonEscape
"syn region pythonString		matchgroup=Normal start=+[uU]\="+ end=+"+ skip=+\\\\\|\\"+
syn region pythonString		matchgroup=Normal start=+[uU]\="""+ end=+"""+ contains=pythonEscape
syn region pythonString		matchgroup=Normal start=+[uU]\='''+ end=+'''+ contains=pythonEscape

" The python string highlighting just doesn't work when the python is in an
" attr, hence this method.
syn region npythonString		matchgroup=Normal start=+[uU]\="+ end=+"+ skip=+\\\\\|\\"+ contains=pythonEscape
hi def link   npythonString    String


syn match kidAttr '\<py:for\>'     containedin=htmlTag contained nextgroup=kidPythonAttr
syn match kidAttr '\<py:if\>'      containedin=htmlTag contained nextgroup=kidPythonAttr
syn match kidAttr '\<py:content\>' containedin=htmlTag contained nextgroup=kidPythonAttr
syn match kidAttr '\<py:replace\>' containedin=htmlTag contained nextgroup=kidPythonAttr
syn match kidAttr '\<py:strip\>'   containedin=htmlTag contained nextgroup=kidPythonAttr
syn match kidAttr '\<py:attrs\>'   containedin=htmlTag contained nextgroup=kidPythonAttr
syn match kidAttr '\<py:def\>'     containedin=htmlTag contained nextgroup=kidPythonAttr
syn match kidAttr '\<py:match\>'   containedin=htmlTag contained nextgroup=kidPythonAttr
syn match kidAttr '\<py:extends\>' containedin=htmlTag contained nextgroup=kidPythonAttr
syn match kidAttr '\<py:content\>' containedin=htmlTag contained nextgroup=kidPythonAttr
syn match kidAttr '\<py:layout\>' containedin=htmlTag contained nextgroup=kidPythonAttr

syn match kidDelims '\${' contained
syn match kidDelims '}' contained
syn match kidDelims '<?python' contained
syn match kidDelims '?>' contained

syn match kidXmlError "&\%(\S\+;\)\@!\|<\%(?\)\@!\|?\@<!>" contained

syntax region kidPython start="<?python" end="?>" contains=kidFunctions,@pythonCode,kidDelims,npythonString,kidXmlError transparent keepend
syntax region kidPython start="\${" end="}" contains=kidFunctions,@pythonCode,kidDelims,npythonString,kidXmlError transparent keepend

syntax region kidPythonAttr start=+\%(=\)"+ end=+"+ contains=kidFunctions,kidPython,kidDelims transparent keepend contained
syntax region kidPython start=+"+hs=s+1, end=+"+he=e-1 contains=kidFunctions,@pythonCode,kidXmlError transparent contained

hi link   kidAttr       PreProc
hi link   kidDelims     Delimiter
hi link   kidXmlError   Error
hi link   kidFunctions  Keyword

let b:current_syntax = "kid"
