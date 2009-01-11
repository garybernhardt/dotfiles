if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet <i <index name=\"".st."key".et."_index\"><CR><index-column name=\"".st."key".et."\" /><CR></index><CR>".st.et
exec "Snippet <t <table name=\"".st."name".et."\" ".st.et."><CR>".st.et."<CR></table><CR>".st.et
exec "Snippet <u <unique name=\"unique_".st."key".et."\"><CR><unique-column name=\"".st."key".et."\" /><CR></unique><CR>".st.et
exec "Snippet <c <column name=\"".st."name".et."\" type=\"".st."type".et."\" ".st.et." /><CR>".st.et
exec "Snippet <p <column name=\"".st."id".et."\" type=\"".st."integer".et."\" required=\"true\" primaryKey=\"true\" autoincrement=\"true\" /><CR>".st.et
exec "Snippet <f <foreign-key foreignTable=\"".st."table".et."\"><CR><reference local=\"".st."table".et."_id\" foreign=\"<id>\"/><CR></foreign-key><CR>".st.et
