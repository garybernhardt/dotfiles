if exists("g:moria_style")
    let s:moria_style = g:moria_style
else
    let s:moria_style = &background
endif

if exists("g:moria_fontface")
    let s:moria_fontface = g:moria_fontface
else
    let s:moria_fontface = "plain"
endif

execute "command! -nargs=1 Colo let g:moria_style = \"<args>\" | colo moria"

if s:moria_style == "black" || s:moria_style == "dark" || s:moria_style == "darkslategray"
    set background=dark
elseif s:moria_style == "light" || s:moria_style == "white"
    set background=light
else
    let s:moria_style = &background 
endif

hi clear

if exists("syntax_on")
    syntax reset
endif

let colors_name = "moria"

if &background == "dark"
    if s:moria_style == "darkslategray"
        hi Normal ctermbg=0 ctermfg=7 guibg=#2f4f4f guifg=#d0d0d0 gui=none

        hi CursorColumn guibg=#404040 gui=none
        hi CursorLine guibg=#404040 gui=none
        hi FoldColumn ctermbg=bg guibg=bg guifg=#9cc5c5 gui=none
        hi LineNr guifg=#9cc5c5 gui=none
        hi NonText ctermfg=8 guibg=bg guifg=#9cc5c5 gui=bold
        hi Pmenu guibg=#75acac guifg=#000000 gui=none
        hi PmenuSbar guibg=#538c8c guifg=fg gui=none
        hi PmenuThumb guibg=#c5dcdc guifg=bg gui=none
        hi SignColumn ctermbg=bg guibg=bg guifg=#9cc5c5 gui=none
        hi StatusLine ctermbg=7 ctermfg=0 guibg=#477878 guifg=fg gui=bold
        hi StatusLineNC ctermbg=8 ctermfg=0 guibg=#3c6464 guifg=fg gui=none
        hi TabLine guibg=#4d8080 guifg=fg gui=underline
        hi TabLineFill guibg=#4d8080 guifg=fg gui=underline
        hi VertSplit ctermbg=7 ctermfg=0 guibg=#3c6464 guifg=fg gui=none
        if version >= 700
            hi Visual ctermbg=7 ctermfg=0 guibg=#538c8c gui=none
        else
            hi Visual ctermbg=7 ctermfg=0 guibg=#538c8c guifg=fg gui=none
        endif
        hi VisualNOS guibg=bg guifg=#88b9b9 gui=bold,underline

        if s:moria_fontface == "mixed"
            hi Folded guibg=#585858 guifg=#c5dcdc gui=bold
        else
            hi Folded guibg=#585858 guifg=#c5dcdc gui=none
        endif
    else
        if s:moria_style == "dark"
            hi Normal ctermbg=0 ctermfg=7 guibg=#2a2a2a guifg=#d0d0d0 gui=none

            hi CursorColumn guibg=#444444 gui=none
            hi CursorLine guibg=#444444 gui=none
        elseif s:moria_style == "black"
            hi Normal ctermbg=0 ctermfg=7 guibg=#000000 guifg=#d0d0d0 gui=none

            hi CursorColumn guibg=#3a3a3a gui=none
            hi CursorLine guibg=#3a3a3a gui=none
        endif
        hi FoldColumn ctermbg=bg guibg=bg guifg=#98a9c9 gui=none
        hi LineNr guifg=#98a9c9 gui=none
        hi NonText ctermfg=8 guibg=bg guifg=#98a9c9 gui=bold
        hi Pmenu guibg=#6f86b3 guifg=#000000 gui=none
        hi PmenuSbar guibg=#4e6592 guifg=fg gui=none
        hi PmenuThumb guibg=#c1ccdf guifg=bg gui=none
        hi SignColumn ctermbg=bg guibg=bg guifg=#98a9c9 gui=none
        hi StatusLine ctermbg=7 ctermfg=0 guibg=#3d5074 guifg=fg gui=bold
        hi StatusLineNC ctermbg=8 ctermfg=0 guibg=#2c3954 guifg=fg gui=none
        hi TabLine guibg=#465c86 guifg=fg gui=underline
        hi TabLineFill guibg=#465c86 guifg=fg gui=underline
        hi VertSplit ctermbg=7 ctermfg=0 guibg=#2c3954 guifg=fg gui=none
        if version >= 700
            hi Visual ctermbg=7 ctermfg=0 guibg=#4e6592 gui=none
        else
            hi Visual ctermbg=7 ctermfg=0 guibg=#4e6592 guifg=fg gui=none
        endif
        hi VisualNOS guibg=bg guifg=#8498bd gui=bold,underline

        if s:moria_fontface == "mixed"
            hi Folded guibg=#585858 guifg=#c1ccdf gui=bold
        else
            hi Folded guibg=#585858 guifg=#c1ccdf gui=none
        endif
    endif
    hi Cursor guibg=#ffa500 guifg=bg gui=none
    hi DiffAdd guibg=#008b00 guifg=fg gui=none
    hi DiffChange guibg=#00008b guifg=fg gui=none
    hi DiffDelete guibg=#8b0000 guifg=fg gui=none
    hi DiffText guibg=#0000cd guifg=fg gui=bold
    hi Directory guibg=bg guifg=#1e90ff gui=none
    hi ErrorMsg guibg=#ee2c2c guifg=#ffffff gui=bold
    hi IncSearch guibg=#e0cd78 guifg=#000000 gui=none
    hi ModeMsg guibg=bg guifg=fg gui=bold
    hi MoreMsg guibg=bg guifg=#7ec0ee gui=bold
    hi PmenuSel guibg=#e0e000 guifg=#000000 gui=none
    hi Question guibg=bg guifg=#e8b87e gui=bold
    hi Search guibg=#90e090 guifg=#000000 gui=none
    hi SpecialKey guibg=bg guifg=#e8b87e gui=none
    if has("spell")
        hi SpellBad guisp=#ee2c2c gui=undercurl
        hi SpellCap guisp=#2c2cee gui=undercurl
        hi SpellLocal guisp=#2ceeee gui=undercurl
        hi SpellRare guisp=#ee2cee gui=undercurl
    endif
    hi TabLineSel guibg=bg guifg=fg gui=bold
    hi Title ctermbg=0 ctermfg=15 guifg=fg gui=bold
    hi WarningMsg guibg=bg guifg=#ee2c2c gui=bold
    hi WildMenu guibg=#e0e000 guifg=#000000 gui=bold

    hi Comment guibg=bg guifg=#d0d0a0 gui=none
    hi Constant guibg=bg guifg=#87df71 gui=none
    hi Error guibg=bg guifg=#ee2c2c gui=none
    hi Identifier guibg=bg guifg=#7ee0ce gui=none
    hi Ignore guibg=bg guifg=bg gui=none
    hi lCursor guibg=#00e700 guifg=#000000 gui=none
    hi MatchParen guibg=#008b8b gui=none
    hi PreProc guibg=bg guifg=#d7a0d7 gui=none
    hi Special guibg=bg guifg=#e8b87e gui=none
    hi Todo guibg=#e0e000 guifg=#000000 gui=none
    hi Underlined guibg=bg guifg=#00a0ff gui=underline    

    if s:moria_fontface == "mixed"
        hi Statement guibg=bg guifg=#7ec0ee gui=bold
        hi Type guibg=bg guifg=#f09479 gui=bold
    else
        hi Statement guibg=bg guifg=#7ec0ee gui=none
        hi Type guibg=bg guifg=#f09479 gui=none
    endif

    hi htmlBold ctermbg=0 ctermfg=15 guibg=bg guifg=fg gui=bold
    hi htmlItalic ctermbg=0 ctermfg=15 guibg=bg guifg=fg gui=italic
    hi htmlUnderline ctermbg=0 ctermfg=15 guibg=bg guifg=fg gui=underline
    hi htmlBoldItalic ctermbg=0 ctermfg=15 guibg=bg guifg=fg gui=bold,italic
    hi htmlBoldUnderline ctermbg=0 ctermfg=15 guibg=bg guifg=fg gui=bold,underline
    hi htmlBoldUnderlineItalic ctermbg=0 ctermfg=15 guibg=bg guifg=fg gui=bold,underline,italic
    hi htmlUnderlineItalic ctermbg=0 ctermfg=15 guibg=bg guifg=fg gui=underline,italic
elseif &background == "light"
    if s:moria_style == "light"
        hi Normal ctermbg=15 ctermfg=0 guibg=#f0f0f0 guifg=#000000 gui=none

        hi CursorColumn guibg=#d4d4d4 gui=none
        hi CursorLine guibg=#d4d4d4 gui=none
    elseif s:moria_style == "white"
        hi Normal ctermbg=15 ctermfg=0 guibg=#ffffff guifg=#000000 gui=none

        hi CursorColumn guibg=#dbdbdb gui=none
        hi CursorLine guibg=#dbdbdb gui=none
    endif
    hi Cursor guibg=#883400 guifg=bg gui=none
    hi DiffAdd guibg=#008b00 guifg=#ffffff gui=none
    hi DiffChange guibg=#00008b guifg=#ffffff gui=none
    hi DiffDelete guibg=#8b0000 guifg=#ffffff gui=none
    hi DiffText guibg=#0000cd guifg=#ffffff gui=bold
    hi Directory guibg=bg guifg=#0000f0 gui=none
    hi ErrorMsg guibg=#ee2c2c guifg=#ffffff gui=bold
    hi FoldColumn ctermbg=bg guibg=bg guifg=#42577d gui=none
    hi Folded guibg=#c5c5c5 guifg=#2c3954 gui=bold
    hi IncSearch guibg=#ffcd78 gui=none
    hi LineNr guifg=#42577d gui=none
    hi ModeMsg ctermbg=15 ctermfg=0 guibg=bg guifg=fg gui=bold
    hi MoreMsg guibg=bg guifg=#1f3f81 gui=bold
    hi NonText ctermfg=8 guibg=bg guifg=#42577d gui=bold
    hi Pmenu guibg=#7b91b9 guifg=#000000 gui=none
    hi PmenuSbar guibg=#5874a7 guifg=fg gui=none
    hi PmenuSel guibg=#ffff00 guifg=#000000 gui=none
    hi PmenuThumb guibg=#adbbd3 guifg=fg gui=none
    hi Question guibg=bg guifg=#813f11 gui=bold
    hi Search guibg=#a0f0a0 gui=none
    hi SignColumn ctermbg=bg guibg=bg guifg=#42577d gui=none
    hi SpecialKey guibg=bg guifg=#912f11 gui=none
    if has("spell")
        hi SpellBad guisp=#ee2c2c gui=undercurl
        hi SpellCap guisp=#2c2cee gui=undercurl
        hi SpellLocal guisp=#008b8b gui=undercurl
        hi SpellRare guisp=#ee2cee gui=undercurl
    endif
    hi StatusLine ctermbg=0 ctermfg=15 guibg=#98a9c9 guifg=fg gui=bold
    hi StatusLineNC ctermbg=7 ctermfg=0 guibg=#adbbd3 guifg=fg gui=none
    hi TabLine guibg=#b1bed6 guifg=fg gui=underline
    hi TabLineFill guibg=#b1bed6 guifg=fg gui=underline
    hi TabLineSel guibg=bg guifg=fg gui=bold
    hi Title guifg=fg gui=bold
    hi VertSplit ctermbg=7 ctermfg=0 guibg=#adbbd3 guifg=fg gui=none
    if version >= 700
        hi Visual ctermbg=7 ctermfg=0 guibg=#c1ccdf gui=none
    else
        hi Visual ctermbg=7 ctermfg=0 guibg=#c1ccdf guifg=fg gui=none
    endif    
    hi VisualNOS guibg=bg guifg=#8498bd gui=bold,underline
    hi WarningMsg guibg=bg guifg=#ee2c2c gui=bold
    hi WildMenu guibg=#ffff00 guifg=fg gui=bold

    hi Comment guibg=bg guifg=#786000 gui=none
    hi Constant guibg=bg guifg=#077807 gui=none
    hi Error guibg=bg guifg=#ee2c2c gui=none
    hi Identifier guibg=bg guifg=#007080 gui=none
    hi Ignore guibg=bg guifg=bg gui=none
    hi lCursor guibg=#008000 guifg=#ffffff gui=none
    hi MatchParen guibg=#00ffff gui=none
    hi PreProc guibg=bg guifg=#800090 gui=none
    hi Special guibg=bg guifg=#912f11 gui=none
    hi Statement guibg=bg guifg=#1f3f81 gui=bold
    hi Todo guibg=#ffff00 guifg=fg gui=none
    hi Type guibg=bg guifg=#912f11 gui=bold
    hi Underlined guibg=bg guifg=#0000cd gui=underline

    hi htmlBold guibg=bg guifg=fg gui=bold
    hi htmlItalic guibg=bg guifg=fg gui=italic
    hi htmlUnderline guibg=bg guifg=fg gui=underline
    hi htmlBoldItalic guibg=bg guifg=fg gui=bold,italic
    hi htmlBoldUnderline guibg=bg guifg=fg gui=bold,underline
    hi htmlBoldUnderlineItalic guibg=bg guifg=fg gui=bold,underline,italic
    hi htmlUnderlineItalic guibg=bg guifg=fg gui=underline,italic
endif
