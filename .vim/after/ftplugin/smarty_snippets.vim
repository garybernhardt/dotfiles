if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet {cycle {cycle values=\"#SELSTART#".st."foo".et.",".st."bar".et."#SELEND#\" name=\"default\" print=true advance=true delimiter=\",\" assign=varname }<CR>".st.et
exec "Snippet |regex_replace |regex_replace:\"".st."regex".et."\":\"".st.et."\"".st.et
exec "Snippet {counter {counter name=\"#INSERTION#\" start=1 skip=1 direction=\"up\" print=true<CR>assign=\"foo\" }<CR><CR>{counter}<CR>".st.et
exec "Snippet {eval {eval var=\"#SELSTART#{template_format}#SELEND#\" assign=varname} <CR>".st.et
"Snippet |date_format |date_format:"${1:strftime() formatting}" <CR><{}>
exec "Snippet |truncate |truncate:".st.et.":".st.et.":".st."false".et.""
exec "Snippet {if {if ".st."varname".et.st.et."<CR>\"".st."foo".et."\"}<CR><CR>{* $varname can also be a php call *}<CR><CR>".st.et."<CR><CR>{/if}<CR>".st.et
"Snippet |string_format |string_format:"${1:sprintf formatting}" <CR><{}>
exec "Snippet {assign {assign var=".st.et." value=\"".st.et."\"}".st.et
exec "Snippet {foreach {foreach from=".st."varname".et." item=i [key=k name=\"\"] }<CR><CR>".st.et."<CR><CR>{/foreach}<CR><CR>".st.et
exec "Snippet {capture {capture name=#INSERTION#}<CR><CR>#SELECT#<CR><CR>{/capture}<CR>".st.et
exec "Snippet |wordwrap |wordwrap:".st.et.":\"".st.et."\":".st.et
exec "Snippet |spacify |spacify:\"".st.et."\"".st.et." "
exec "Snippet |default |default:\"".st.et."\"".st.et
exec "Snippet {debug {debug output=\"#SELSTART#".st.et."#SELEND#\" }".st.et
exec "Snippet |replace |replace:\"".st."needle".et."\":\"".st.et."\"".st.et
exec "Snippet {include {include file=\"".st.et."\" [assign=varname foo=\"bar\"] }".st.et
exec "Snippet |escape |escape:\"".st.et."\"".st.et
exec "Snippet {strip {strip}<CR>".st.et."<CR>{/strip}".st.et
exec "Snippet {math {math equation=\"".st.et."\" assign=".st.et." ".st.et."}".st.et
exec "Snippet {config_load {config_load file=\"#INSERTION#\" [section=\"\" scope=\"local|parent|global\"] }".st.et
exec "Snippet |cat  |cat:\"".st.et."\"".st.et
exec "Snippet {insert {insert name=\"insert_".st.et."\" [assign=varname script=\"foo.php\" foo=\"bar\"] }".st.et
exec "Snippet {fetch {fetch file=\"#SELSTART#http:// or file#SELEND#\" assign=varname}".st.et
exec "Snippet {literal {literal}<CR><CR>".st.et."<CR><CR>{/literal}".st.et
exec "Snippet {include_php {include_php file=\"".st.et."\" [once=true]}".st.et
exec "Snippet |strip |strip:[\"".st.et."\"]".st.et
