if !exists('loaded_cfg_bundle_dot_vim')
    let g:loaded_cfg_bundle_dot_vim = 1
else
    finish
endif

let g:mdx_vimrc_dir           = g:rc_root . '/vimrc.d'
let g:mdx_configs_dir         = g:mdx_vimrc_dir . '/configs.d'
let g:mdx_bundles_dir         = g:mdx_vimrc_dir . '/bundles.d'

let g:mdx_bundle_manager      = 'NeoBundle'
let g:mdx_bundle_objs         = []
let g:mdx_sourced                 = []
let g:mdx_bundles_to_register = []
let g:mdx_loaded_bundles      = []


function s:MergeConfig(cfg_name)
    " return if ever sourced beforereturn, else record it.
    if index(g:mdx_sourced, a:cfg_name) != -1
        return
    else
        call add(g:mdx_sourced, a:cfg_name)
    endif

    call s:CommitBundlesIn(g:mdx_bundles_to_register)
    let g:mdx_bundles_to_register = []

    execute 'source ' . g:mdx_configs_dir . '/' . a:cfg_name
    call s:CommitBundlesIn(g:mdx_bundles_to_register)
endfunction

function s:CommitBundlesIn(lst)
    for b in a:lst
        if index(g:mdx_loaded_bundles, b) == -1
            call add(g:mdx_loaded_bundles, b)
        endif
    endfor
endfunction

function s:Register2Neobundle()
    execute "NeoBundle " . string(g:mdx_bundle.site) . ', ' . string(g:mdx_bundle.neodict)
    call add(g:mdx_bundle_objs, g:mdx_bundle)
    unlet g:mdx_bundle
endfunction

function s:RegisterBundles()
    " used in configs.d/* to source sub config files.
    command -nargs=1 MergeConfig  call s:MergeConfig(<q-args>)

    execute "source " . g:mdx_vimrc_dir . '/cur_config'

    call s:CommitBundlesIn(g:mdx_bundles_to_register)
    unlet g:mdx_bundles_to_register

    for b in g:mdx_loaded_bundles
        let g:mdx_bundle = {}
        let g:mdx_bundle.neodict = {}
        execute 'source ' . g:mdx_bundles_dir . '/' . b

        "call s:Register2{g:mdx_bundle_manager}()
        call s:Register2Neobundle()
    endfor

    " clean up functions & commands
    delcommand MergeConfig
    delfunction s:MergeConfig
    delfunction s:CommitBundlesIn
endfunction

function s:LoadBundleConfigs()
    for b in g:mdx_bundle_objs
        call b.config()
    endfor
    unlet g:mdx_bundle_objs
endfunction

function s:ParsePlusReg()
    "let g:regex = '[^/"' . "']" . '\+\%(github\.com\)\@</\%([^/"' . "'" . ']\%(\.git\)\@\)\+'
    let g:regex = 'https://github\.com/[^/]\+/[^/]\+\.git'

    for l:x in [@", @+, @*, @a]
        let g:shortened = matchstr(l:x, g:regex)
        if len(g:shortened) > 0
            break
        endif
    endfor

    " returns an empty string if parsing failed.
    return g:shortened
endfunction

function mudox#cfg_bundle#EditBundle(name)
    let l:file_name = g:mdx_bundles_dir . '/' . a:name
    let l:open_cmd  = mudox#query_open_file#Main() " gvie user chance to cancel.

    if filereadable(l:file_name)
        " read template content
        let l:tmpl = readfile(g:mdx_vimrc_dir . '/bundle_template')
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
        let l:file_path = g:mdx_configs_dir . '/' . g:mdx_config_name
        execute mudox#query_open_file#Main() . l:file_path
    else " edit a new or existing config.
        let l:file_path = g:mdx_configs_dir . '/' . l:names[0]

        if filereadable(l:file_path)
            execute mudox#query_open_file#Main() . l:file_path
        else
            " gvie user chance to cancel.
            let l:open_cmd  = mudox#query_open_file#Main()

            " read template content if any.
            let l:tmpl_path = g:mdx_configs_dir . '/'
                        \ . (len(l:names) == 2 ? l:names[1] : '../config_template')
            echo l:tmpl_path

            if filereadable(l:tmpl_path)
                let l:tmpl = readfile(l:tmpl_path)
            else
                echoerr "Template file " . l:tmpl_path . ' unreadable'
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

function mudox#cfg_bundle#VundleInit()
endfunction

function mudox#cfg_bundle#PathogenInit()
endfunction

function mudox#cfg_bundle#NeoBundleInit()
    set nocompatible                " Recommend

    if has('vim_starting')
        exe 'set runtimepath+=' . escape(g:rc_root, '\ ') . '/neobundle/neobundle'
    endif

    call neobundle#rc(g:vim_config_root . '/neobundle')

    " Let neobundle manage neobundle
    NeoBundleFetch 'Shougo/neobundle.vim' , { 'name' : 'neobundle' }

    execute 'NeoBundleLocal ' . escape(g:rc_root, '\ ') . '/bundle'

    " * * * * * * * * * * * * * * * * * * *
    call s:RegisterBundles()
    " * * * * * * * * * * * * * * * * * * *

    filetype plugin indent on       " Required!

    " Installation check.
    NeoBundleCheck

    if !has('vim_starting')
        " Call on_source hook when reloading .vimrc.
        call neobundle#call_hook('on_source')
    endif

    " mapping \neo to update and show update log.
    nnoremap \neo <Esc>:NeoBundleUpdate<CR>:NeoBundleUpdatesLog<CR>

    " load bundle configurations.
    call s:LoadBundleConfigs()
endfunction
