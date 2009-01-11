if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet to to ".st."name".et." ".st."argument".et."<CR>".st.et."<CR>end<CR>".st.et
