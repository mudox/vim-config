let s:vimrc_dir = g:rc_root . '/vimrc.d'
let s:neobundles_dir = s:vimrc_dir . '/neobundles.d'
function! mudox#cfg_bundle#Main(name)
    let l:file_name = s:neobundles_dir . '/' . a:name
    let l:open_cmd = mudox#query_open_file#Main() " gvie user chance to cancel.

    if !filereadable(l:file_name)
        " create en empty buffer and fill it with template.
        let l:tmpl = readfile(s:vimrc_dir . '/neobundle_template', 'b')
        call writefile(l:tmpl, l:file_name, 'b')
    endif
    execute  l:open_cmd . l:file_name
endfunction
