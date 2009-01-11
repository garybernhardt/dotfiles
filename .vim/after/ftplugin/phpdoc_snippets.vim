if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet doc_d /**<CR>* ".st."undocumentedConstant".et."<CR>**/<CR>define(".st.et.", ".st.et.");".st.et."<CR>".st.et
exec "Snippet doc_vp /**<CR>* ".st."undocumentedClassVariable".et."<CR>*<CR>* @var ".st."string".et.st.et."<CR>**/".st.et."<CR>"
exec "Snippet doc_f /**<CR>* ".st."undocumentedFunction".et."<CR>*<CR>* @return ".st."void".et."<CR>* @author ".st.et."<CR>**/<CR>".st.et."function ".st.et."(".st.et.")<CR>{".st.et."<CR>}<CR>".st.et
exec "Snippet doc_s /**<CR>* ".st."undocumentedFunction".et."<CR>*<CR>* @return ".st."void".et."<CR>* @author ".st.et."<CR>**/<CR>".st.et."function ".st.et."(".st.et.");<CR>".st.et
exec "Snippet doc_h /**<CR>* ".st.et."<CR>*<CR>* @author ".st.et."<CR>* @version $Id$<CR>* @copyright ".st.et.", ".st.et."<CR>* @package ".st."default".et."<CR>**/<CR><CR>/**<CR>* Define DocBlock<CR>**/<CR><CR>".st.et
exec "Snippet doc_fp /**<CR>* ".st."undocumentedFunction".et."<CR>*<CR>* @return ".st."void".et."<CR>* @author ".st.et."<CR>**/".st.et."<CR>"
exec "Snippet doc_i /**<CR>* ".st."undocumentedClass".et."<CR>*<CR>* @package ".st."default".et."<CR>* @author ".st.et."<CR>**/<CR>interface ".st.et."<CR>{".st.et."<CR>} // END interface ".st.et."<CR>".st.et
exec "Snippet doc_fp /**<CR>* ".st."undocumentedConstant".et.st.et."<CR>**/".st.et."<CR>".st.et
exec "Snippet doc_v /**<CR>* ".st."undocumentedClassVariable".et."<CR>*<CR>* @var ".st."string".et."<CR>**/<CR><var> $".st.et.";".st.et."<CR>".st.et
exec "Snippet doc_cp /**<CR>* ".st."undocumentedClass".et."<CR>*<CR>* @package ".st."default".et."<CR>* @author ".st.et."<CR>**/".st.et
exec "Snippet doc_c /**<CR>* ".st."undocumentedClass".et."<CR>*<CR>* @package ".st."default".et."<CR>* @author ".st.et."<CR>**/<CR>".st."class".et."class ".st."a".et."<CR>{".st.et."<CR>} // END ".st."class".et."class ".st."a".et."<CR>".st.et
