if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet do do: [| :".st."each".et."| ".st.et."]<CR>".st.et
exec "Snippet proto define: #".st."NewName".et." &parents: {".st."parents".et."} &slots: {".st."slotSpecs".et."}.<CR>".st.et
exec "Snippet ifte ".st."condition".et." ifTrue: [".st.et.":then] ifFalse: [".st.et.":else]<CR>".st.et
exec "Snippet collect collect: [| :".st."each".et."| ".st.et."]<CR>".st.et
exec "Snippet if ".st."condition".et." ifTrue: [".st.et.":then]".st.et
exec "Snippet until [".st."condition".et."] whileFalse: [".st.et.":body]".st.et
exec "Snippet reject reject: [| :".st."each".et."| ".st.et."]<CR>".st.et
exec "Snippet dowith doWithIndex: [| :".st."each".et." :".st."index".et." | ".st.et."]<CR>".st.et
exec "Snippet select select: [| :".st."each".et."| ".st.et."]".st.et
exec "Snippet while [".st."condition".et."] whileTrue: [".st.et.":body]".st.et
exec "Snippet inject inject: ".st."object".et." [| :".st."injection".et.", :".st."each".et."| ".st.et."]".st.et
