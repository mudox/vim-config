let g:mudox_vimrc_dir   = g:rc_root . '/vimrc.d'
let g:mudox_configs_dir = g:mudox_vimrc_dir . '/configs.d'
let g:mudox_bundles_dir = g:mudox_vimrc_dir . '/bundles.d'

function mudox#cfg_bundle#EditBundle(name)
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
        let l:git_repo = s:ParsePlusReg()
        if len(git_repo) > 0
            let l:n = match(l:tmpl, 'let s:repo = " TODO:')
            let l:tmpl[l:n] = substitute(l:tmpl[l:n], '" TODO:.*$', "'" . l:git_repo . "'", '')
        endif

        call append(0, l:tmpl)
        normal dd " delete trailling empty line.

        call cursor(1, 1)
        call search("let s:repo = '.", 'e')
        normal zO
    endif

    if l:open_cmd =~? 'tabnew'
        normal '<C-W>x'
    endif
endfunction

function mudox#cfg_bundle#EditConfig(arg)
    let l:names = split(a:arg, '\s')
    if len(l:names) > 2
        echoerr 'Too many arguments, at most 2 arguemnts is needed'
        return
    endif

    if len(l:names) == 0 " Edit current config.
        let l:file_path = g:mudox_configs_dir . '/' . g:mdx_config_name
        execute mudox#query_open_file#Main() . l:file_path
    else " edit a new or existing config.
        let l:file_path = g:mudox_configs_dir . '/' . l:names[0]

        if filereadable(l:file_path)
            execute mudox#query_open_file#Main() . l:file_path
        else
            " gvie user chance to cancel.
            let l:open_cmd  = mudox#query_open_file#Main() 

            " read template content if any.
            let l:tmpl_path = g:mudox_configs_dir . '/' 
                        \ . (len(l:names) == 2 ? l:names[1] : '../config_template')
            echo l:tmpl_path

            if filereadable(l:tmpl_path)
                let l:tmpl = readfile(l:tmpl_path)
            else
                echoerr "Template file " . l:tmpl_path . ' unreadable!'
                echoerr "creating an empty config ..."
            endif

            execute  l:open_cmd . l:file_path

            if exists('l:tmpl')
                setlocal filetype=vim
                setlocal foldmethod=marker
                setlocal fileformat=unix
                call append(0, l:tmpl)
                normal dd
            endif
        endif
    endif
endfunction

function mudox#cfg_bundle#LoadBundleConfigs()
    for b in g:neo_bundles
        call g:CONFIG_PLUGIN_{b}()
        unlet! g:CONFIG_PLUGIN_{b}
    endfor
endfunction

function mudox#cfg_bundle#RegisterBundles()
    let g:neo_bundles = []


    " used in configs.d/* to source sub config files.
    command -nargs=1 MergeConfig  execute 'source ' . g:mudox_configs_dir . '/' . <q-args>

    execute "source " . g:mudox_vimrc_dir . '/cur_config'

    " filter g:neo_bundles
    let l:copy = copy(g:neo_bundles)
    let g:neo_bundles = []
    for b in l:copy
        " no unavailable bundles.
        if !filereadable(g:mudox_bundles_dir . '/' . b)
            echoerr 'Unavailabled bundle [' . b . ']'
            continue
        endif
        
        " no duplicated bundles.
        if index(g:neo_bundles, b) != -1
            continue
        endif

        call add(g:neo_bundles, b)
    endfor

    for b in g:neo_bundles
        execute 'source ' . g:mudox_bundles_dir . '/' . b
    endfor

    delcommand MergeConfig
endfunction

function! s:ParsePlusReg()
    let g:regex = '\zs[^/"' . "']" . '\+\%(github.com\)\@<!/\%([^/"' . "'" . ']\%(\.git\)\@!\)\+\ze'

    for l:x in [@", @+, @*, @a]
        let g:shortened = matchstr(l:x, g:regex)
        if len(g:shortened) > 0
            break
        endif
    endfor

    " returns an empty string if parsing failed.
    return g:shortened
endfunction
