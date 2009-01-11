if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet wrap [% WRAPPER ".st."template".et." %]<CR>".st.et."<CR>[% END %]<CR>".st.et
exec "Snippet if [% IF ".st."condition".et." %]<CR>".st.et."<CR>[% ELSE %]<CR>".st.et."<CR>[% END %]<CR>".st.et
exec "Snippet unl [% UNLESS ".st."condition".et." %]<CR>".st.et."<CR>[% END %]<CR>".st.et
exec "Snippet inc [% INCLUDE ".st."template".et." %]<CR>".st.et
exec "Snippet for  [% FOR ".st."var".et." IN ".st."set".et." %]<CR>".st.et."<CR>[% END %]".st.et
