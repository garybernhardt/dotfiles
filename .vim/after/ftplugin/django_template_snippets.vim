if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet {{ {% templatetag openvariable %}".st.et
exec "Snippet }} {% templatetag closevariable %}".st.et
exec "Snippet {% {% templatetag openblock %}".st.et
exec "Snippet %} {% templatetag closeblock %}".st.et
exec "Snippet now {% now \"".st.et."\" %}".st.et
exec "Snippet firstof {% firstof ".st.et." %}".st.et
exec "Snippet ifequal {% ifequal ".st.et." ".st.et." %}<CR>".st.et."<CR>{% endifequal %}<CR>".st.et
exec "Snippet ifchanged {% ifchanged %}".st.et."{% endifchanged %}".st.et
exec "Snippet regroup {% regroup ".st.et." by ".st.et." as ".st.et." %}".st.et
exec "Snippet extends {% extends \"".st.et."\" %}<CR>".st.et
exec "Snippet filter {% filter ".st.et." %}<CR>".st.et."<CR>{% endfilter %}".st.et
exec "Snippet block {% block ".st.et." %}<CR>".st.et."<CR>{% endblock %}<CR>".st.et
exec "Snippet cycle {% cycle ".st.et." as ".st.et." %}".st.et
exec "Snippet if {% if ".st.et." %}<CR>".st.et."<CR>{% endif %}<CR>".st.et
exec "Snippet debug {% debug %}<CR>".st.et
exec "Snippet ifnotequal {% ifnotequal ".st.et." ".st.et." %}<CR>".st.et."<CR>{% endifnotequal %}<CR>".st.et
exec "Snippet include {% include ".st.et." %}<CR>".st.et
exec "Snippet comment {% comment %}<CR>".st.et."<CR>{% endcomment %}<CR>".st.et
exec "Snippet for {% for ".st.et." in ".st.et." %}<CR>".st.et."<CR>{% endfor %}<CR>".st.et
exec "Snippet ssi {% ssi ".st.et." ".st.et." %}".st.et
exec "Snippet widthratio {% widthratio ".st.et." ".st.et." ".st.et." %}".st.et
exec "Snippet load {% load ".st.et." %}<CR>".st.et
" Field snippet contributed by Alex Pounds
exec "Snippet field <p><label for=\"id_".st."fieldname".et."\">".st."fieldlabel".et.":</label> {{ form.".st."fieldname".et." }}<CR>{% if form.".st."fieldname".et.".errors %}*** {{ form.".st."fieldname".et.".errors|join:\", \" }} {% endif %}</p>".st.et
