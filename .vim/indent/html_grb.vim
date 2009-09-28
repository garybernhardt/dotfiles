" [-- helper function to assemble tag list --]
fun! <SID>HtmlIndentPush(tag)
    if exists('g:html_indent_tags')
        let g:html_indent_tags = g:html_indent_tags.'\|'.a:tag
    else
        let g:html_indent_tags = a:tag
    endif
endfun
call <SID>HtmlIndentPush('p')
call <SID>HtmlIndentPush('li')
