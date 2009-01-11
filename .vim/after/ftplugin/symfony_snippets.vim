if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet image_tag image_tag('".st."imageName".et."'".st.et.")".st.et
exec "Snippet get public function get".st.et." ()<CR>{<CR>return $this->".st.et.";<CR>}<CR><CR>".st.et
exec "Snippet link_to link_to('".st."linkName".et."', '".st."moduleName".et."/".st."actionName".et.st.et."')".st.et
exec "Snippet sexecute public function execute<Action>()<CR>{<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet set public function set".st.et." ($".st.et.")<CR>{<CR>$this->".st.et." = ".st.et.";<CR>}<CR><CR>".st.et
exec "Snippet execute /**<CR>* ".st."className".et."<CR>*<CR>*/<CR>public function execute<Action>()<CR>{<CR>".st.et."<CR>}<CR>".st.et
exec "Snippet tforeach <?php foreach ($".st."variable".et." as $".st."key".et.st.et."): ?><CR>".st.et."<CR><?php endforeach ?><CR>".st.et
exec "Snippet getparam $this->getRequestParameter('".st."id".et."')".st.et
exec "Snippet div <div".st.et."><CR>".st.et."<CR></div>".st.et
exec "Snippet tif <?php if (".st."condition".et."): ?><CR>".st.et."<CR><?php endif ?><CR>".st.et
exec "Snippet setget public function set".st."var".et." (".st."arg".et.")<CR>{<CR>$this->".st."arg".et." = ".st."arg".et.";<CR>}<CR><CR>public function get".st."var".et." ()<CR>{<CR>return $this->".st."var".et.";<CR>}<CR><CR>".st.et
exec "Snippet echo <?php echo ".st.et." ?>".st.et
exec "Snippet tfor <?php for($".st."i".et." = ".st.et."; $".st."i".et." <= ".st.et."; $".st."i".et."++): ?><CR>".st.et."<CR><?php endfor ?><CR>".st.et
