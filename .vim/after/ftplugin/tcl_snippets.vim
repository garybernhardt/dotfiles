if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet switch switch ".st.et." -- $".st."var".et." {<CR>".st."match".et." {<CR>".st.et."<CR>}<CR>default<CR>{".st.et."}<CR>}<CR>".st.et
exec "Snippet foreach foreach ".st."var".et." $".st."list".et." {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet proc proc ".st."name".et." {".st."args".et."} <CR>{<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet if if {".st."condition".et."} {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet for for {".st."i".et." {".st.et."} {".st.et."} {<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet while while {".st."condition".et."} {<CR>".st.et."<CR>}<CR>".st.et
