" Based on
runtime colors/ir_black.vim

let g:colors_name = "grb4"

hi pythonSpaceError ctermbg=red guibg=red

hi Comment ctermfg=darkyellow

hi StatusLine ctermbg=lightgrey ctermfg=black
hi StatusLineNC ctermbg=lightgrey ctermfg=black
hi VertSplit ctermbg=lightgrey ctermfg=black
hi LineNr ctermfg=lightgrey

" ir_black doesn't highlight operators for some reason
hi Operator        guifg=#6699CC     guibg=NONE        gui=NONE      ctermfg=lightblue   ctermbg=NONE        cterm=NONE

