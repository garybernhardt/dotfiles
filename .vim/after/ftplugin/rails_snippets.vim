if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet mrnt rename_table \"".st."oldTableName".et."\", \"".st."newTableName".et."\"".st.et
exec "Snippet rfu render :file => \"".st."filepath".et."\", :use_full_path => ".st."false".et.st.et
exec "Snippet rns render :nothing => ".st."true".et.", :status => ".st.et.st.et
exec "Snippet ri render :inline => \"".st.et."\")>\"".st.et
exec "Snippet rt render :text => \"".st.et."\"".st.et
exec "Snippet mcc t.column \"".st."title".et."\", :".st."string".et.st.et
exec "Snippet rpl render :partial => \"".st."item".et."\", :locals => { :".st."name".et." => \"".st."value".et."\"".st.et." }".st.et
exec "Snippet rea redirect_to :action => \"".st."index".et."\"".st.et
exec "Snippet rtlt render :text => \"".st.et."\", :layout => ".st."true".et.st.et
exec "Snippet ft <%= form_tag :action => \"".st."update".et."\" %>".st.et
exec "Snippet forin <% for ".st."item".et." in ".st.et." %><CR><Tab><%= ".st."item".et.".".st."name".et." %><CR><% end %><CR>".st.et
exec "Snippet lia <%= link_to \"".st.et."\", :action => \"".st."index".et."\" %>".st.et
exec "Snippet rl render :layout => \"".st."layoutname".et."\"".st.et
exec "Snippet ra render :action => \"".st."action".et."\"".st.et
exec "Snippet mrnc rename_column \"".st."table".et."\", \"".st."oldColumnName".et."\", \"".st."newColumnName".et."\"".st.et
exec "Snippet mac add_column \"".st."table".et."\", \"".st."column".et."\", :".st."string".et.st.et
exec "Snippet rpc render :partial => \"".st."item".et."\", :collection => ".st."items".et.st.et
exec "Snippet rec redirect_to :controller => \"".st."items".et."\"".st.et
exec "Snippet rn render :nothing => ".st."true".et.st.et
exec "Snippet lic <%= link_to \"".st.et."\", :controller => \"".st.et."\" %>".st.et
exec "Snippet rpo render :partial => \"".st."item".et."\", :object => ".st."object".et.st.et
exec "Snippet rts render :text => \"".st.et."\", :status => ".st.et
exec "Snippet rcea render_component :action => \"".st."index".et."\"".st.et
exec "Snippet recai redirect_to :controller => \"".st."items".et."\", :action => \"".st."show".et."\", :id => ".st.et
exec "Snippet mcdt create_table \"".st."table".et."\" do |t|<CR><Tab>".st.et."<CR>end<CR>".st.et
exec "Snippet ral render :action => \"".st."action".et."\", :layout => \"".st."layoutname".et."\"".st.et
exec "Snippet rit render :inline => \"".st.et."\", :type => ".st.et
exec "Snippet rceca render_component :controller => \"".st."items".et."\", :action => \"".st."index".et."\"".st.et
exec "Snippet licai <%= link_to \"".st.et."\", :controller => \"".st."items".et."\", :action => \"".st."edit".et."\", :id => ".st.et." %>".st.et
exec "Snippet verify verify :only => [:".st.et."], :method => :post, :render => {:status => 500, :text => \"use HTTP-POST\"}".st.et
exec "Snippet mdt drop_table \"".st."table".et."\"".st.et
exec "Snippet rp render :partial => \"".st."item".et."\"".st.et
exec "Snippet rcec render_component :controller => \"".st."items".et."\"".st.et
exec "Snippet mrc remove_column \"".st."table".et."\", \"".st."column".et."\"".st.et
exec "Snippet mct create_table \"".st."table".et."\" do |t|<CR><Tab>".st.et."<CR>end<CR>".st.et
exec "Snippet flash flash[:".st."notice".et."] = \"".st.et."\"".st.et
exec "Snippet rf render :file => \"".st."filepath".et."\"".st.et
exec "Snippet lica <%= link_to \"".st.et."\", :controller => \"".st."items".et."\", :action => \"".st."index".et."\" %>".st.et
exec "Snippet liai <%= link_to \"".st.et."\", :action => \"".st."edit".et."\", :id => ".st.et." %>".st.et
exec "Snippet reai redirect_to :action => \"".st."show".et."\", :id => ".st.et
exec "Snippet logi logger.info \"".st.et."\"".st.et
exec "Snippet marc add_column \"".st."table".et."\", \"".st."column".et."\", :".st."string".et."<CR><CR>".st.et."<CR>".st.et
exec "Snippet rps render :partial => \"".st."item".et."\", :status => ".st.et
exec "Snippet ril render :inline => \"".st.et."\", :locals => { ".st.et." => \"".st."value".et."\"".st.et." }".st.et
exec "Snippet rtl render :text => \"".st.et."\", :layout => \"".st.et."\"".st.et
exec "Snippet reca redirect_to :controller => \"".st."items".et."\", :action => \"".st."list".et."\"".st.et
