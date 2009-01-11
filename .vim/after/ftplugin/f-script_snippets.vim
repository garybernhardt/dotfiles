if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet tbd to:".st.et." by:".st.et." do:[ ".st.et." |<CR>".st.et."<CR>].".st.et
exec "Snippet it ifTrue:[<CR>".st.et."<CR>].".st.et
exec "Snippet ift ifFalse:[<CR>".st.et."<CR>] ifTrue:[<CR>".st.et."<CR>].".st.et
exec "Snippet itf ifTrue:[<CR>".st.et."<CR>] ifFalse:[<CR>".st.et."<CR>].".st.et
exec "Snippet td to:".st.et." do:[".st.et." ".st.et." |<CR>".st.et."<CR>].".st.et
exec "Snippet if ifFalse:[<CR>".st.et."<CR>].".st.et
