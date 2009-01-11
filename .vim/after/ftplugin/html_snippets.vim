if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

function! SelectDoctype()
    let st = g:snip_start_tag
    let et = g:snip_end_tag
    let cd = g:snip_elem_delim
    let dt = inputlist(['Select doctype:',
                \ '1. HTML 4.01',
                \ '2. HTML 4.01 Transitional',
                \ '3. HTML 4.01 Frameset',
                \ '4. XHTML 1.0 Frameset',
                \ '5. XHTML Strict',
                \ '6. XHTML Transitional',
                \ '7. XHTML Frameset'])
    let dts = {1: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n\"http://www.w3.org/TR/html4/strict.dtd\">\n".st.et,
             \ 2: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"\n\"http://www.w3.org/TR/html4/loose.dtd\">\n".st.et,
             \ 3: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\"\n\"http://www.w3.org/TR/html4/frameset.dtd\">\n".st.et,
             \ 4: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Frameset//EN\"\n\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\">\n".st.et,
             \ 5: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML Strict//EN\"\n\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n".st.et,
             \ 6: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML Transitional//EN\"\n\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n".st.et,
             \ 7: "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML Frameset//EN\"\n\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\">\n".st.et}
    
    return dts[dt]
endfunction

exec "Snippet doct ``SelectDoctype()``"
exec "Snippet doctype <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Frameset//EN\"<CR><TAB>\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\"><CR>".st.et
exec "Snippet doc4s <!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"<CR>\"http://www.w3.org/TR/html4/strict.dtd\"><CR>".st.et
exec "Snippet doc4t <!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"<CR>\"http://www.w3.org/TR/html4/loose.dtd\"><CR>".st.et
exec "Snippet doc4f <!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\"<CR>\"http://www.w3.org/TR/html4/frameset.dtd\"><CR>".st.et
exec "Snippet docxs <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML Strict//EN\"<CR>\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\"><CR>".st.et
exec "Snippet docxt <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML Transitional//EN\"<CR>\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><CR>".st.et
exec "Snippet docxf <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML Frameset//EN\"<CR>\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\"><CR>".st.et
exec "Snippet head <head><CR><meta http-equiv=\"Content-type\" content=\"text/html; charset=utf-8\" /><CR><title>".st.et."</title><CR>".st.et."<CR></head><CR>".st.et
exec "Snippet script <script type=\"text/javascript\" language=\"javascript\" charset=\"utf-8\"><CR>// <![CDATA[<CR><TAB>".st.et."<CR>// ]]><CR></script><CR>".st.et
exec "Snippet title <title>".st.et."</title>"
exec "Snippet body <body id=\"".st.et."\" ".st.et."><CR>".st.et."<CR></body><CR>".st.et
exec "Snippet scriptsrc <script src=\"".st.et."\" type=\"text/javascript\" language=\"".st.et."\" charset=\"".st.et."\"></script><CR>".st.et
exec "Snippet textarea <textarea name=\"".st.et."\" rows=\"".st.et."\" cols=\"".st.et."\">".st.et."</textarea><CR>".st.et
exec "Snippet meta <meta name=\"".st.et."\" content=\"".st.et."\" /><CR>".st.et
exec "Snippet movie <object width=\"".st.et."\" height=\"".st.et."\"<CR>classid=\"clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B\"<CR>codebase=\"http://www.apple.com/qtactivex/qtplugin.cab\"><CR><param name=\"src\"<CR>value=\"".st.et."\" /><CR><param name=\"controller\" value=\"".st.et."\" /><CR><param name=\"autoplay\" value=\"".st.et."\" /><CR><embed src=\"".st.et."\"<CR>width=\"".st.et."\" height=\"".st.et."\"<CR>controller=\"".st.et."\" autoplay=\"".st.et."\"<CR>scale=\"tofit\" cache=\"true\"<CR>pluginspage=\"http://www.apple.com/quicktime/download/\"<CR>/><CR></object><CR>".st.et
exec "Snippet div <div ".st.et."><CR>".st.et."<CR></div><CR>".st.et
exec "Snippet mailto <a href=\"mailto:".st.et."?subject=".st.et."\">".st.et."</a>".st.et
exec "Snippet table <table border=\"".st.et."\"".st.et." cellpadding=\"".st.et."\"><CR><tr><th>".st.et."</th></tr><CR><tr><td>".st.et."</td></tr><CR></table>"
exec "Snippet link <link rel=\"".st.et."\" href=\"".st.et."\" type=\"text/css\" media=\"".st.et."\" title=\"".st.et."\" charset=\"".st.et."\" />"
exec "Snippet form <form action=\"".st.et."\" method=\"".st.et."\"><CR>".st.et."<CR><CR><p><input type=\"submit\" value=\"Continue &rarr;\" /></p><CR></form><CR>".st.et
exec "Snippet ref <a href=\"".st.et."\">".st.et."</a>".st.et
exec "Snippet h1 <h1 id=\"".st.et."\">".st.et."</h1>".st.et
exec "Snippet input <input type=\"".st.et."\" name=\"".st.et."\" value=\"".st.et."\" ".st.et."/>".st.et
exec "Snippet style <style type=\"text/css\" media=\"screen\"><CR>/* <![CDATA[ */<CR>".st.et."<CR>/* ]]> */<CR></style><CR>".st.et
exec "Snippet base <base href=\"".st.et."\"".st.et." />".st.et
