if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet img ![".st."altText".et."](".st."SRC".et.")".st.et
exec "Snippet link [".st."desc".et."](".st."HREF".et.")".st.et
