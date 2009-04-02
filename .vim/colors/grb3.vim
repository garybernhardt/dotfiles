" Based on
runtime colors/ir_black.vim

let g:colors_name = "grb"

hi pythonSpaceError ctermbg=red guibg=red

" hi Comment ctermfg=darkyellow

hi Normal guibg=#101010
hi NonText guibg=#101010
hi LineNr guibg=#101010

hi CursorLine guibg=#181818
hi CursorColumn guibg=#181818

hi VertSplit guifg=#303030 guibg=#303030
hi StatusLine guifg=#000000 guibg=#a0a0a0
hi StatusLineNC guifg=#888888 guibg=#303030

" ir_black doesn't highlight operators for some reason
hi Operator        guifg=#6699CC     guibg=NONE        gui=NONE      ctermfg=lightblue   ctermbg=NONE        cterm=NONE

