if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet Queue Queue.fold ".st.et." ".st."base".et." ".st."q".et."<CR>".st.et
exec "Snippet Nativeint Nativeint.abs ".st."ni".et.st.et
exec "Snippet Printexc Printexc.print ".st."fn".et." ".st."x".et.st.et
exec "Snippet Sys Sys.Signal_ignore".st.et
exec "Snippet Hashtbl Hashtbl.iter ".st.et." ".st."h".et.st.et
exec "Snippet Array Array.map ".st.et." ".st."arr".et.st.et
exec "Snippet Printf Printf.fprintf ".st."buf".et." \"".st."format".et."\" ".st."args".et.st.et
exec "Snippet Stream Stream.iter ".st.et." ".st."stream".et.st.et
exec "Snippet Buffer Buffer.add_channel ".st."buf".et." ".st."ic".et." ".st."len".et.st.et
exec "Snippet Int32 Int32.abs ".st."i32".et.st.et
exec "Snippet List List.rev_map ".st.et." ".st."lst".et.st.et
exec "Snippet Scanf Scanf.bscaf ".st."sbuf".et." \"".st."format".et."\" ".st."f".et.st.et
exec "Snippet Int64 Int64.abs ".st."i64".et.st.et
exec "Snippet Map Map.Make ".st.et
exec "Snippet String String.iter ".st.et." ".st."str".et.st.et
exec "Snippet Genlex Genlex.make_lexer ".st."\"tok_lst\"".et." ".st."\"char_stream\"".et.st.et
exec "Snippet for for ".st."i}".et." = ".st.et." to ".st.et." do<CR>".st.et."<CR>done<CR>".st.et
exec "Snippet Stack Stack.iter ".st.et." ".st."stk".et.st.et
