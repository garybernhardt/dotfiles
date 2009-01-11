if !exists('loaded_snippet') || &cp
    finish
endif

function! UpFirst()
    return substitute(@z,'.','\u&','')
endfunction

function! Count(haystack, needle)
    let counter = 0
    let index = match(a:haystack, a:needle)
    while index > -1
        let counter = counter + 1
        let index = match(a:haystack, a:needle, index+1)
    endwhile
    return counter
endfunction

function! ObjCArgList(count)
    let st = g:snip_start_tag
    let et = g:snip_end_tag

    if a:count == 0
        return st.et
    else
        return st.et.repeat(', '.st.et, a:count)
    endif
endfunction


let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet cat @interface ".st."NSObject".et." (".st."Category".et.")<CR><CR>@end<CR><CR><CR>@implementation ".st."NSObject".et." (".st."Category".et.")<CR><CR>".st.et."<CR><CR>@end<CR>".st.et
exec "Snippet delacc - (id)delegate;<CR><CR>- (void)setDelegate:(id)delegate;<CR>".st.et
exec "Snippet ibo IBOutlet ".st."NSSomeClass".et." *".st."someClass".et.";<CR>".st.et
exec "Snippet dict NSMutableDictionary *".st."dict".et." = [NSMutableDictionary dictionary];<CR>".st.et
exec "Snippet Imp #import <".st.et.".h><CR>".st.et
exec "Snippet objc @interface ".st."class".et." : ".st."NSObject".et."<CR>{<CR>}<CR>@end<CR><CR>@implementation ".st."class".et."<CR>- (id)init<CR>{<CR>self = [super init]; <CR>if (self != nil)<CR>{<CR>".st.et."<CR>}<CR>return self;<CR>}<CR>@end<CR>".st.et
exec "Snippet imp #import \"".st.et.".h\"<CR>".st.et
exec "Snippet bez NSBezierPath *".st."path".et." = [NSBezierPath bezierPath];<CR>".st.et
exec "Snippet acc - (".st."\"unsigned int\"".et.")".st."thing".et."<CR>{<CR>return ".st."fThing".et.";<CR>}<CR><CR>- (void)set".st."thing:UpFirst()".et.":(".st."\"unsigned int\"".et.")new".st."thing:UpFirst()".et."<CR>{<CR>".st."fThing".et." = new".st."thing:UpFirst()".et.";<CR>}<CR>".st.et
exec "Snippet format [NSString stringWithFormat:@\"".st.et."\", ".st.et."]".st.et
exec "Snippet focus [self lockFocus];<CR><CR>".st.et."<CR><CR>[self unlockFocus];<CR>".st.et
exec "Snippet setprefs [[NSUserDefaults standardUserDefaults] setObject:".st."object".et." forKey:".st."key".et."];<CR>".st.et
exec "Snippet log NSLog(@\"%s".st."s".et."\", ".st."s:ObjCArgList(Count(@z, '%[^%]'))".et.");".st.et
exec "Snippet gsave [NSGraphicsContext saveGraphicsState];<CR>".st.et."<CR>[NSGraphicsContext restoreGraphicsState];<CR>".st.et
exec "Snippet forarray for(unsigned int index = 0; index < [".st."array".et." count]; index += 1)<CR>{<CR>".st."id".et."object = [".st."array".et." objectAtIndex:index];<CR>".st.et."<CR>}".st.et
exec "Snippet classi @interface ".st."ClassName".et." : ".st."NSObject".et."<CR><CR>{".st.et."<CR><CR>}<CR><CR>".st.et."<CR><CR>@end<CR>".st.et
exec "Snippet array NSMutableArray *".st."array".et." = [NSMutableArray array];".st.et
exec "Snippet getprefs [[NSUserDefaults standardUserDefaults] objectForKey:<key>];".st.et
exec "Snippet cati @interface ".st."NSObject".et." (".st."Category".et.")<CR><CR>".st.et."<CR><CR>@end<CR>".st.et
