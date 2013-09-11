let g:mudox_vimrc_dir   = g:rc_root . '/vimrc.d'
let g:mudox_configs_dir = g:mudox_vimrc_dir . '/configs.d'
let g:mudox_bundles_dir = g:mudox_vimrc_dir . '/bundles.d'

function! mudox#cfg_bundle#EditBundle(name)
    let l:file_name = g:mudox_bundles_dir . '/' . a:name
    let l:open_cmd  = mudox#query_open_file#Main() " gvie user chance to cancel.

    if !filereadable(l:file_name)
        " read template content
       let l:tmpl = readfile(g:mudox_vimrc_dir . '/bundle_template')
    endif

    if l:open_cmd =~? 'tabnew'
        execute 'tabnew ' . g:rc_root . '/vimrc'
        execute 'vnew ' . g:mudox_configs_dir . '/all_old'
        let l:open_cmd = 'vnew '
    endif

    execute  l:open_cmd . l:file_name

    if exists('l:tmpl')
        setlocal filetype=vim
        setlocal foldmethod=marker
        setlocal fileformat=unix
        call append(0, l:tmpl)
    endif

    if l:open_cmd =~? 'tabnew'
        normal '<C-W>x'
    endif
endfunction

function! mudox#cfg_bundle#EditConfig(name)
    let l:file_name = g:mudox_configs_dir . '/' . a:name
    let l:open_cmd  = mudox#query_open_file#Main() " gvie user chance to cancel.

    if !filereadable(l:file_name)
        " read template content
        let l:tmpl = readfile(g:mudox_vimrc_dir . '/config_template')
    endif

    execute  l:open_cmd . l:file_name

    if exists('l:tmpl')
        setlocal filetype=vim
        setlocal foldmethod=marker
        setlocal fileformat=unix
        call append(0, l:tmpl)
    endif
endfunction

function mudox#cfg_bundle#LoadBundleConfigs()
    for b in g:neo_bundles
        call g:CONFIG_PLUGIN_{b}()
    endfor
endfunction

function mudox#cfg_bundle#RegisterBundles()
    let g:neo_bundles = []

    execute "source " . g:mudox_vimrc_dir . '/cur_config'

    for b in g:neo_bundles
        execute 'source ' . g:mudox_bundles_dir . '/' . b
    endfor
endfunction
