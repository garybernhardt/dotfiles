" Based on
runtime colors/ir_black.vim

let g:colors_name = "grb256"

hi pythonSpaceError ctermbg=red guibg=red

hi Comment ctermfg=darkgray

hi StatusLine ctermbg=darkgrey ctermfg=white
hi StatusLineNC ctermbg=black ctermfg=lightgrey
hi VertSplit ctermbg=black ctermfg=lightgrey
hi LineNr ctermfg=darkgray
hi CursorLine     guifg=NONE        guibg=#121212     gui=NONE      ctermfg=NONE        ctermbg=234
hi Function         guifg=#FFD2A7     guibg=NONE        gui=NONE      ctermfg=yellow       ctermbg=NONE        cterm=NONE
hi Visual           guifg=NONE        guibg=#262D51     gui=NONE      ctermfg=NONE        ctermbg=236    cterm=NONE

" ir_black doesn't highlight operators for some reason
hi Operator        guifg=#6699CC     guibg=NONE        gui=NONE      ctermfg=lightblue   ctermbg=NONE        cterm=NONE

