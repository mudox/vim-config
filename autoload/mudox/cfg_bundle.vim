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

    " if it is creating a new bundle, fill it with appropriate template.
    if exists('l:tmpl')
        setlocal filetype=vim
        setlocal foldmethod=marker
        setlocal fileformat=unix

        " fill with template.
        " if register + got a valid git repo address, then automatically
        " insert the shrotened address into appropriate place.
        let git_repo = s:ParsePlusReg()
        if len(git_repo)
            let l:n = match(l:tmpl, 'let s:repo = " TODO:')
            let l:tmpl[l:n] = substitute(l:tmpl[l:n], '" TODO:.*$', l:git_repo, '')
        endif

        call append(0, l:tmpl)

        call cursor(1, 1)
        call search("let s:repo = '.", 'e')
        normal zO
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

function! s:ParsePlusReg()
    let l:shortened = matchstr(@+, '^https://github\.com/\zs.*\ze\.git$')

    if len(l:shortened) > 0
        return "'" . l:shortened . "'"
    else
        return ''
    endif
endfunction