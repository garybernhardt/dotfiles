if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet cat <$MTCategoryDescription$>".st.et
exec "Snippet blog <$MTBlogName$>".st.et
exec "Snippet archive <$MTArchiveFile$>".st.et
exec "Snippet cal <MTCalendarIfEntries><CR><Tab>".st.et."<CR></MTCalendarIfEntries><CR>".st.et
exec "Snippet entry <$MTEntryMore$>".st.et
exec "Snippet entries <MTEntriesHeader><CR><Tab>".st.et."<CR></MTEntriesHeader><CR>".st.et
