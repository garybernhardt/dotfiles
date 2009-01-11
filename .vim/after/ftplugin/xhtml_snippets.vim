if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet doctype <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"<CR>\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\"><CR>".st.et
exec "Snippet aref <a href=\"".st.et."\" id=\"".st.et."\" title=\"".st.et."\">".st.et."</a>".st.et
exec "Snippet head  <head><CR>".st.et."<CR></head>".st.et
exec "Snippet script <script type=\"text/javascript\" language=\"<javascript>\" charset=\"".st.et."\"><CR>// <![CDATA[<CR>".st.et."<CR>// ]]><CR></script>".st.et
exec "Snippet html <html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"".st."en".et."\"<CR>lang=\"".st."en".et."\"><CR>".st.et."<CR></html>"
exec "Snippet h3 <h3>".st.et."</h3>".st.et
exec "Snippet h4 <h4>".st.et."</h4>".st.et
exec "Snippet h5 <h5>".st.et."</h5>".st.et
exec "Snippet h6 <h6>".st.et."</h6>".st.et
exec "Snippet fieldset <fieldset><CR>".st.et."<CR></fieldset>".st.et
exec "Snippet noscript <noscript><CR>".st.et."<CR></noscript>".st.et
exec "Snippet ul <ul ".st.et."><CR>".st.et."<CR></ul>".st.et
exec "Snippet xml <?xml version=\"1.0\" encoding=\"iso-8859-1\"?><CR><CR>".st.et
exec "Snippet body <body id=\"".st.et."\" ".st.et."><CR>".st.et."<CR></body>".st.et
exec "Snippet legend <legend align=\"".st.et."\" accesskey=\"".st.et."\"><CR>".st.et."<CR></legend>".st.et
exec "Snippet title <title>".st."PageTitle".et."</title>".st.et
exec "Snippet scriptsrc <script src=\"".st.et."\" type=\"text/javascript\" language=\"<javascript>\" charset=\"".st.et."\"></script>".st.et
exec "Snippet img <img src=\"".st.et."\" alt=\"".st.et."\" class=\"".st.et."\" />".st.et
exec "Snippet option <option label=\"".st."label".et."\" value=\"".st."value".et."\" ".st.et."></option> ".st.et
exec "Snippet optgroup <optgroup label=\"".st."Label".et."\"><CR>".st.et."<CR></optgroup>".st.et
exec "Snippet meta <meta name=\"".st."name".et."\" content=\"".st."content".et."\" />".st.et
exec "Snippet td <td ".st.et.">".st.et."</td>".st.et
exec "Snippet dt <dt>".st.et."<CR></dt><CR><dd>".st.et."</dd>".st.et
exec "Snippet tfoot <tfoot><CR>".st.et."<CR></tfoot>".st.et
exec "Snippet div <!-- begin div.".st."id".et." --><CR><div id=\"".st."id".et."\"><CR>".st.et."<CR></div><CR><!-- end div.".st."id".et." --><CR>".st.et
exec "Snippet ol <ol ".st.et."><CR>".st.et."<CR></ol>".st.et
exec "Snippet txtarea <textarea id=\"".st."ID".et."\" name=\"".st."Name".et."\" rows=\"".st.et."\" cols=\"".st.et."\" tabindex=\"".st.et."\" ".st.et.">".st.et."</textarea>".st.et
exec "Snippet mailto <a href=\"mailto:".st.et."?subject=".st.et."\">".st.et."</a>".st.et
exec "Snippet table <table summary=\"".st."Summary".et."\" class=\"".st."className".et."\" width=\"".st.et."\" cellspacing=\"".st.et."\" cellpadding=\"".st.et."\" border=\"".st.et."\"><CR>".st.et."<CR></table>".st.et
exec "Snippet hint <span class=\"hint\">".st.et."</span>".st.et
exec "Snippet link <link rel=\"".st."stylesheet".et."\" href=\"".st.et."\" type=\"text/css\" media=\"".st."screen".et."\" title=\"".st.et."\" charset=\"".st.et."\" />".st.et
exec "Snippet form <form action=\"".st."urlToGoTo".et."\" method=\"".st."get".et."\" id=\"".st."formID".et."\" name=\"".st."formName".et."\"><CR>".st.et."<CR></form>".st.et
exec "Snippet tr <tr ".st.et."><CR>".st.et."<CR></tr>".st.et
exec "Snippet label <label for=\"".st."inputItem".et."\">".st.et."</label>".st.et
exec "Snippet image <img src=\"".st.et."\" alt=\"".st.et."\" width=\"".st.et."\" height=\"".st.et."\" ".st.et."/>".st.et
exec "Snippet input <input name=\"".st.et."\" id=\"".st.et."\" type=\"radio\" value=\"".st."defaultValue".et."\" tabindex=\"".st.et."\" ".st.et." />".st.et
exec "Snippet select <select id=\"".st."ID".et."\" name=\"".st."Name".et."\" size=\"".st.et."\" tabindex=\"".st.et."\" ".st.et."><CR>".st.et."<CR></select><CR>".st.et
exec "Snippet style <style type=\"text/css\" media=\"".st."screen".et."\"><CR>/* <![CDATA[ */<CR>".st.et."<CR>/* ]]> */<CR></style><CR>".st.et
exec "Snippet divheader <!-- Begin HeaderDiv:: --><CR><div id=\"HeaderDiv\"><CR><!--logo in background --><CR><h1>".st."CompanyName".et."</h1><CR></div><CR><!-- End HeaderDiv:: --><CR>".st.et
exec "Snippet base <base href=\"".st.et."\" ".st.et."/>".st.et
