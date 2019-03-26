" grb256 color scheme
" Based on ir_black <http://blog.infinitered.com/entries/show/8>
runtime colors/ir_black.vim

let g:colors_name = "grb256"

" These colors are taken from iTerm2's 'pastel' color scheme. The name of
" 'cyan' is somewhat inaccurate, since it's referring to the color that iTerm2
" assigned to the 16-color-terminal 'cyan' color, rather than true cyan.
" However, the names are at least roughly correct.
let s:black = "#000000"
let s:gray = "#616161"
let s:lightgray = "#8e8e8e"
let s:red = "#ff8272"
let s:lightred = "#ffc4bd"
let s:green = "#b4fa72"
let s:lightgreen = "#d6fcb9"
let s:yellow = "#fefdc2"
let s:lightyellow = "#fefdd5"
let s:blue = "#a5d5fe"
let s:lightblue = "#c1e3fe"
let s:magenta = "#ff8ffd"
let s:lightmagenta = "#ffb1fe"
let s:cyan = "#d0d1fe"
let s:lightcyan = "#e5e6fe"
let s:white = "#f1f1f1"
let s:lightwhite = "#feffff"

let s:none = "NONE"
let s:reverse = "reverse"
let s:bold = "BOLD"
let s:underline = "underline"

" Additional colors.
let s:darkgray = "#202020"
let s:darkred = "#770000"
let s:darkorange = "#773c00"

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "grb24bit"


" General colors. Forgive me for the way that all of this is formatted.
exe 'hi Normal          guifg='.s:none          .' guibg='.s:none           .' cterm='.s:none
exe 'hi NonText         guifg='.s:black         .' guibg='.s:none           .' cterm='.s:none

exe 'hi Cursor          guifg='.s:black         .' guibg='.s:lightwhite     .' cterm='.s:reverse
exe 'hi LineNr          guifg='.s:lightgray     .' guibg='.s:none           .' cterm='.s:none

exe 'hi VertSplit       guifg='.s:lightgray     .' guibg='.s:lightgray      .' cterm='.s:none
exe 'hi StatusLine      guifg='.s:black         .' guibg='.s:white          .' cterm='.s:none
exe 'hi StatusLineNC    guifg='.s:black         .' guibg='.s:lightgray      .' cterm='.s:none  

exe 'hi Folded          guifg='.s:none          .' guibg='.s:none           .' cterm='.s:none
exe 'hi Title           guifg='.s:none          .' guibg='.s:none           .' cterm='.s:none
exe 'hi Visual          guifg='.s:none          .' guibg='.s:gray           .' cterm='.s:reverse

exe 'hi SpecialKey      guifg='.s:none          .' guibg='.s:none           .' cterm='.s:none

exe 'hi WildMenu        guifg='.s:black         .' guibg='.s:lightyellow    .' cterm='.s:none
exe 'hi PmenuSbar       guifg='.s:black         .' guibg='.s:lightwhite     .' cterm='.s:none
exe 'hi Ignore          guifg='.s:none          .' guibg='.s:none           .' cterm='.s:none

exe 'hi Error           guifg='.s:lightwhite    .' guibg='.s:darkred        .' cterm='.s:none
exe 'hi ErrorMsg        guifg='.s:lightwhite    .' guibg='.s:darkred        .' cterm='.s:none
exe 'hi WarningMsg      guifg='.s:lightwhite    .' guibg='.s:darkorange     .' cterm='.s:none

" Message displayed in lower left, such as --INSERT--
exe 'hi ModeMsg         guifg='.s:black         .' guibg='.s:lightred       .' cterm='.s:bold

exe 'hi CursorLine      guifg='.s:none          .' guibg='.s:darkgray       .' cterm='.s:none
exe 'hi CursorColumn    guifg='.s:none          .' guibg='.s:none           .' cterm='.s:bold
exe 'hi MatchParen      guifg='.s:lightwhite    .' guibg='.s:lightgray      .' cterm='.s:none

" Omnicompletion (<c-n> and <c-p>)
exe 'hi Pmenu           guifg='.s:black         .' guibg='.s:white          .' cterm='.s:none
exe 'hi PmenuSel        guifg='.s:black         .' guibg='.s:magenta        .' cterm='.s:none

exe 'hi Search          guifg='.s:none          .' guibg='.s:none           .' cterm='.s:underline    .' ctermfg=NONE ctermbg=NONE'

" Syntax highlighting
exe 'hi Comment         guifg='.s:lightgray     .' guibg='.s:none           .' cterm='.s:none
exe 'hi String          guifg='.s:lightgreen    .' guibg='.s:none           .' cterm='.s:none
exe 'hi Number          guifg='.s:lightmagenta  .' guibg='.s:none           .' cterm='.s:none

exe 'hi Keyword         guifg='.s:lightblue     .' guibg='.s:none           .' cterm='.s:none
exe 'hi Operator        guifg='.s:lightblue     .' guibg='.s:none           .' cterm='.s:none
exe 'hi PreProc         guifg='.s:lightblue     .' guibg='.s:none           .' cterm='.s:none
exe 'hi Conditional     guifg='.s:lightblue     .' guibg='.s:none           .' cterm='.s:none

exe 'hi Todo            guifg='.s:lightred      .' guibg='.s:none           .' cterm='.s:none
exe 'hi Constant        guifg='.s:lightcyan     .' guibg='.s:none           .' cterm='.s:none

exe 'hi Identifier      guifg='.s:lightblue     .' guibg='.s:none           .' cterm='.s:none
exe 'hi Function        guifg='.s:yellow        .' guibg='.s:none           .' cterm='.s:none
exe 'hi Type            guifg='.s:lightyellow   .' guibg='.s:none           .' cterm='.s:none
exe 'hi Statement       guifg='.s:lightblue     .' guibg='.s:none           .' cterm='.s:none

exe 'hi Special         guifg='.s:lightwhite    .' guibg='.s:none           .' cterm='.s:none
exe 'hi Delimiter       guifg='.s:lightcyan     .' guibg='.s:none           .' cterm='.s:none

" The spelling highlights are used for errors (e.g. vim-ale uses it).
exe 'hi SpellBad        guifg='.s:none          .' guibg='.s:darkred        .' cterm='.s:none
exe 'hi SpellCap        guibg='.s:none          .' guibg='.s:darkorange     .' cterm='.s:none


hi link Character       Constant
hi link Boolean         Constant
hi link Float           Number
hi link Repeat          Statement
hi link Label           Statement
hi link Exception       Statement
hi link Include         PreProc
hi link Define          PreProc
hi link Macro           PreProc
hi link PreCondit       PreProc
hi link StorageClass    Type
hi link Structure       Type
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link SpecialComment  Special
hi link Debug           Special


" Special for Ruby
exe 'hi rubyRegexp                  guifg='.s:yellow              .' guibg='.s:none      .' cterm='.s:none
exe 'hi rubyRegexpDelimiter         guifg='.s:yellow              .' guibg='.s:none      .' cterm='.s:none
exe 'hi rubyEscape                  guifg='.s:lightcyan           .' guibg='.s:none      .' cterm='.s:none
exe 'hi rubyInterpolationDelimiter  guifg='.s:lightblue           .' guibg='.s:none      .' cterm='.s:none
exe 'hi rubyControl                 guifg='.s:lightblue           .' guibg='.s:none      .' cterm='.s:none
exe 'hi rubyStringDelimiter         guifg='.s:lightgreen          .' guibg='.s:none      .' cterm='.s:none
"rubyGlobalVariable
"rubyInclude
"rubySharpBang
"rubyAccess
"rubyPredefinedVariable
"rubyBoolean
"rubyClassVariable
"rubyBeginEnd
"rubyRepeatModifier
"rubyCurlyBlock  { , , }

hi link rubyClass             Keyword 
hi link rubyModule            Keyword 
hi link rubyKeyword           Keyword 
hi link rubyOperator          Operator
hi link rubyIdentifier        Identifier
hi link rubyInstanceVariable  Identifier
hi link rubyGlobalVariable    Identifier
hi link rubyClassVariable     Identifier
hi link rubyConstant          Type  


" Special for XML
hi link xmlTag          Keyword 
hi link xmlTagName      Conditional 
hi link xmlEndTag       Identifier 


" Special for HTML
hi link htmlTag         Keyword 
hi link htmlTagName     Conditional 
hi link htmlEndTag      Identifier 


" Special for Javascript
hi link javaScriptNumber      Number 
