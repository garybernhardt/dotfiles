
"   ___  __)                   )   ___                  ______)
"  (,  |/                     (__/_____)   /)          (, /      /)  /)
"      |  _/_  _  __  ____      /      ___// _____       /  _   (/_ //  _
"   ) /|_ (___(/_/ (_/ / /_  (_/      (_)(/_(_)/ (_   ) /  (_(_/_) (/__(/_
"  (_/                        (______)               (_/
"
"                                           guns <self@sungpae.com>

" Version:  1.6
" License:  MIT
" Homepage: http://github.com/guns/xterm-color-table.vim
"
" NOTES:
"
"   * Provides command :XtermColorTable, as well as variants for different splits
"   * Xterm numbers on the left, equivalent RGB values on the right
"   * Press `#` to yank current color (shortcut for yiw)
"   * Press `t` to toggle RGB text visibility
"   * Press `f` to set RGB text to current color
"   * Buffer behavior similar to Scratch.vim
"
" INSPIRED BY:
"
"   * http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
"   * http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
"   * http://www.vim.org/scripts/script.php?script_id=664


" We have a dependency on buffer-local autocommands
if version < 700
    echo 'FAIL: XtermColorTable requires vim 7.0+'
    finish
endif

let s:bufname = '__XtermColorTable__'

if !exists('g:XtermColorTableDefaultOpen')
    let g:XtermColorTableDefaultOpen = 'split'
endif


command! XtermColorTable  execute 'call <SID>XtermColorTable(g:XtermColorTableDefaultOpen)'
command! SXtermColorTable call <SID>XtermColorTable('split')
command! VXtermColorTable call <SID>XtermColorTable('vsplit')
command! TXtermColorTable call <SID>XtermColorTable('tabnew')
command! EXtermColorTable call <SID>XtermColorTable('edit')
command! OXtermColorTable call <SID>XtermColorTable('edit') | only


augroup XtermColorTable "{{{
    autocmd!
    autocmd BufNewFile  __XtermColorTable__ call <SID>ColorTable()
    autocmd ColorScheme *                   silent! doautoall XtermColorTableBuffer ColorScheme
augroup END "}}}


function! <SID>XtermColorTable(open) "{{{
    let bufid = bufnr(s:bufname)
    let winid = bufwinnr(bufid)

    if bufid == -1
        " Create new buffer
        execute a:open.' '.s:bufname
        return
    elseif winid != -1 && winnr('$') > 1
        " Close extant window
        execute winid.'wincmd w' | close
    endif

    " Open extant buffer
    execute a:open.' +buffer'.bufid
endfunction "}}}


function! <SID>ColorTable() "{{{
    let rows = []

    call add(rows, <SID>ColorRow(0,  7))
    call add(rows, <SID>ColorRow(8, 15))
    call add(rows, '')

    for lnum in range(16, 250, 6)
        call add(rows, <SID>ColorRow(lnum, lnum + 5))
        if lnum == 226
            call add(rows, '')
        endif
    endfor

    if &modifiable
        call append(0, rows)
        call append(len(rows) + 1, <SID>HelpComment())
        call <SID>SetBufferOptions()
    endif
endfunction "}}}


function! <SID>ColorRow(start, end) "{{{
    return join(map(range(a:start, a:end), '<SID>ColorCell(v:val)'))
endfunction "}}}


function! <SID>ColorCell(n) "{{{
    let rgb = s:xterm_colors[a:n]

    " Clear extant values
    execute 'silent! syntax clear fg_'.a:n
    execute 'silent! syntax clear bg_'.a:n

    execute 'syntax match fg_'.a:n.' " '.a:n.' " containedin=ALL'
    execute 'syntax match bg_'.a:n.' "'. rgb .'" containedin=ALL'

    call <SID>HighlightCell(a:n, -1)

    return printf(' %3s %7s', a:n, rgb)
endfunction "}}}


function! <SID>HighlightCell(n, bgf) "{{{
    let rgb = s:xterm_colors[a:n]

    " bgf has three states:
    "   -2) black or white depending on intensity
    "   -1) same as background
    "   0+) xterm color value
    if a:bgf == -2
        let sum = 0
        for val in map(split(substitute(rgb, '^#', '', ''), '\v\x{2}\zs'), 'str2nr(v:val, 16)')
            " TODO: does Vimscript have a fold/reduce function?
            let sum += val
        endfor
        let bgf = sum > (0xff * 1.5) ? 0 : 15
    elseif a:bgf == -1
        let bgf = a:n
    else
        let bgf = a:bgf
    endif

    " Clear any extant values
    execute 'silent! highlight clear fg_'.a:n
    execute 'silent! highlight clear bg_'.a:n

    execute 'highlight fg_'.a:n.' ctermfg='.a:n.' guifg='.rgb
    execute 'highlight bg_'.a:n.' ctermbg='.a:n.' guibg='.rgb
    execute 'highlight bg_'.a:n.' ctermfg='.bgf.' guifg='.s:xterm_colors[bgf]
endfunction "}}}


function! <SID>SetBufferOptions() "{{{
    setlocal buftype=nofile bufhidden=hide buflisted
    setlocal nomodified nomodifiable noswapfile readonly
    setlocal nocursorline nocursorcolumn
    setlocal iskeyword+=#

    let b:XtermColorTableRgbVisible = 0
    let b:XtermColorTableBGF = -2

    nmap <silent><buffer> # yiw:echo 'yanked: '.@"<CR>
    nmap <silent><buffer> t :call <SID>ToggleRgbVisibility()<CR>
    nmap <silent><buffer> f :call <SID>SetRgbForeground(expand('<cword>'))<CR>

    " Colorschemes often call `highlight clear';
    " register a handler to deal with this
    augroup XtermColorTableBuffer
        autocmd! * <buffer>
        autocmd ColorScheme <buffer> call <SID>HighlightTable(-1)
    augroup END
endfunction "}}}


function! <SID>HelpComment() "{{{
    " we have to define our own comment type
    silent! syntax clear XtermColorTableComment
    syntax match XtermColorTableComment ';.*'
    highlight link XtermColorTableComment Comment

    let lines = []
    call add(lines, "; # to copy current color (yiw)")
    call add(lines, "; t to toggle RGB visibility")
    call add(lines, "; f to set RGB foreground color")

    return lines
endfunction "}}}


function! <SID>ToggleRgbVisibility() "{{{
    let bgf = b:XtermColorTableRgbVisible ? -1 : b:XtermColorTableBGF
    let b:XtermColorTableRgbVisible = (b:XtermColorTableRgbVisible + 1) % 2

    call <SID>HighlightTable(bgf)
endfunction "}}}


function! <SID>HighlightTable(bgf) "{{{
    for val in range(0, 0xff) | call <SID>HighlightCell(val, a:bgf) | endfor
endfunction "}}}


function! <SID>SetRgbForeground(cword) "{{{
    if len(a:cword)
        let sname = synIDattr(synID(line('.'), col('.'), 0), 'name')
        let b:XtermColorTableBGF = substitute(sname, '\v^\w+_', '', '') + 0
    else
        let b:XtermColorTableBGF = -2
    endif

    if b:XtermColorTableRgbVisible
        call <SID>HighlightTable(b:XtermColorTableBGF)
    else
        call <SID>ToggleRgbVisibility()
    endif
endfunction "}}}


""" Xterm 256 color dictionary {{{

let s:xterm_colors = {
    \ '0':   '#000000', '1':   '#800000', '2':   '#008000', '3':   '#808000', '4':   '#000080',
    \ '5':   '#800080', '6':   '#008080', '7':   '#c0c0c0', '8':   '#808080', '9':   '#ff0000',
    \ '10':  '#00ff00', '11':  '#ffff00', '12':  '#0000ff', '13':  '#ff00ff', '14':  '#00ffff',
    \ '15':  '#ffffff', '16':  '#000000', '17':  '#00005f', '18':  '#000087', '19':  '#0000af',
    \ '20':  '#0000df', '21':  '#0000ff', '22':  '#005f00', '23':  '#005f5f', '24':  '#005f87',
    \ '25':  '#005faf', '26':  '#005fdf', '27':  '#005fff', '28':  '#008700', '29':  '#00875f',
    \ '30':  '#008787', '31':  '#0087af', '32':  '#0087df', '33':  '#0087ff', '34':  '#00af00',
    \ '35':  '#00af5f', '36':  '#00af87', '37':  '#00afaf', '38':  '#00afdf', '39':  '#00afff',
    \ '40':  '#00df00', '41':  '#00df5f', '42':  '#00df87', '43':  '#00dfaf', '44':  '#00dfdf',
    \ '45':  '#00dfff', '46':  '#00ff00', '47':  '#00ff5f', '48':  '#00ff87', '49':  '#00ffaf',
    \ '50':  '#00ffdf', '51':  '#00ffff', '52':  '#5f0000', '53':  '#5f005f', '54':  '#5f0087',
    \ '55':  '#5f00af', '56':  '#5f00df', '57':  '#5f00ff', '58':  '#5f5f00', '59':  '#5f5f5f',
    \ '60':  '#5f5f87', '61':  '#5f5faf', '62':  '#5f5fdf', '63':  '#5f5fff', '64':  '#5f8700',
    \ '65':  '#5f875f', '66':  '#5f8787', '67':  '#5f87af', '68':  '#5f87df', '69':  '#5f87ff',
    \ '70':  '#5faf00', '71':  '#5faf5f', '72':  '#5faf87', '73':  '#5fafaf', '74':  '#5fafdf',
    \ '75':  '#5fafff', '76':  '#5fdf00', '77':  '#5fdf5f', '78':  '#5fdf87', '79':  '#5fdfaf',
    \ '80':  '#5fdfdf', '81':  '#5fdfff', '82':  '#5fff00', '83':  '#5fff5f', '84':  '#5fff87',
    \ '85':  '#5fffaf', '86':  '#5fffdf', '87':  '#5fffff', '88':  '#870000', '89':  '#87005f',
    \ '90':  '#870087', '91':  '#8700af', '92':  '#8700df', '93':  '#8700ff', '94':  '#875f00',
    \ '95':  '#875f5f', '96':  '#875f87', '97':  '#875faf', '98':  '#875fdf', '99':  '#875fff',
    \ '100': '#878700', '101': '#87875f', '102': '#878787', '103': '#8787af', '104': '#8787df',
    \ '105': '#8787ff', '106': '#87af00', '107': '#87af5f', '108': '#87af87', '109': '#87afaf',
    \ '110': '#87afdf', '111': '#87afff', '112': '#87df00', '113': '#87df5f', '114': '#87df87',
    \ '115': '#87dfaf', '116': '#87dfdf', '117': '#87dfff', '118': '#87ff00', '119': '#87ff5f',
    \ '120': '#87ff87', '121': '#87ffaf', '122': '#87ffdf', '123': '#87ffff', '124': '#af0000',
    \ '125': '#af005f', '126': '#af0087', '127': '#af00af', '128': '#af00df', '129': '#af00ff',
    \ '130': '#af5f00', '131': '#af5f5f', '132': '#af5f87', '133': '#af5faf', '134': '#af5fdf',
    \ '135': '#af5fff', '136': '#af8700', '137': '#af875f', '138': '#af8787', '139': '#af87af',
    \ '140': '#af87df', '141': '#af87ff', '142': '#afaf00', '143': '#afaf5f', '144': '#afaf87',
    \ '145': '#afafaf', '146': '#afafdf', '147': '#afafff', '148': '#afdf00', '149': '#afdf5f',
    \ '150': '#afdf87', '151': '#afdfaf', '152': '#afdfdf', '153': '#afdfff', '154': '#afff00',
    \ '155': '#afff5f', '156': '#afff87', '157': '#afffaf', '158': '#afffdf', '159': '#afffff',
    \ '160': '#df0000', '161': '#df005f', '162': '#df0087', '163': '#df00af', '164': '#df00df',
    \ '165': '#df00ff', '166': '#df5f00', '167': '#df5f5f', '168': '#df5f87', '169': '#df5faf',
    \ '170': '#df5fdf', '171': '#df5fff', '172': '#df8700', '173': '#df875f', '174': '#df8787',
    \ '175': '#df87af', '176': '#df87df', '177': '#df87ff', '178': '#dfaf00', '179': '#dfaf5f',
    \ '180': '#dfaf87', '181': '#dfafaf', '182': '#dfafdf', '183': '#dfafff', '184': '#dfdf00',
    \ '185': '#dfdf5f', '186': '#dfdf87', '187': '#dfdfaf', '188': '#dfdfdf', '189': '#dfdfff',
    \ '190': '#dfff00', '191': '#dfff5f', '192': '#dfff87', '193': '#dfffaf', '194': '#dfffdf',
    \ '195': '#dfffff', '196': '#ff0000', '197': '#ff005f', '198': '#ff0087', '199': '#ff00af',
    \ '200': '#ff00df', '201': '#ff00ff', '202': '#ff5f00', '203': '#ff5f5f', '204': '#ff5f87',
    \ '205': '#ff5faf', '206': '#ff5fdf', '207': '#ff5fff', '208': '#ff8700', '209': '#ff875f',
    \ '210': '#ff8787', '211': '#ff87af', '212': '#ff87df', '213': '#ff87ff', '214': '#ffaf00',
    \ '215': '#ffaf5f', '216': '#ffaf87', '217': '#ffafaf', '218': '#ffafdf', '219': '#ffafff',
    \ '220': '#ffdf00', '221': '#ffdf5f', '222': '#ffdf87', '223': '#ffdfaf', '224': '#ffdfdf',
    \ '225': '#ffdfff', '226': '#ffff00', '227': '#ffff5f', '228': '#ffff87', '229': '#ffffaf',
    \ '230': '#ffffdf', '231': '#ffffff', '232': '#080808', '233': '#121212', '234': '#1c1c1c',
    \ '235': '#262626', '236': '#303030', '237': '#3a3a3a', '238': '#444444', '239': '#4e4e4e',
    \ '240': '#585858', '241': '#606060', '242': '#666666', '243': '#767676', '244': '#808080',
    \ '245': '#8a8a8a', '246': '#949494', '247': '#9e9e9e', '248': '#a8a8a8', '249': '#b2b2b2',
    \ '250': '#bcbcbc', '251': '#c6c6c6', '252': '#d0d0d0', '253': '#dadada', '254': '#e4e4e4',
    \ '255': '#eeeeee', 'fg': 'fg', 'bg': 'bg', 'NONE': 'NONE' }

"}}}
