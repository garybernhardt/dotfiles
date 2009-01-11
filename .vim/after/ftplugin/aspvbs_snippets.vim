if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet rr Response.Redirect(".st."to".et.")".st.et.""
exec "Snippet app Application(\"".st.et."\")".st.et.""
exec "Snippet forin For ".st."var".et." in ".st."array".et."<CR>".st.et."<CR>Next<CR>".st.et.""
exec "Snippet ifelse If ".st."condition".et." Then<CR>".st.et."<CR>Else<CR>".st.et."<CR>End if<CR>".st.et.""
exec "Snippet rw Response.Write ".st.et.""
exec "Snippet sess Session(\"".st.et."\")".st.et.""
exec "Snippet rf Request.Form(\"".st.et."\")".st.et.""
exec "Snippet rq Request.QueryString(\"".st.et."\")".st.et.""
exec "Snippet while While ".st."NOT".et." ".st."condition".et."<CR>".st.et."<CR>Wend<CR>".st.et.""
