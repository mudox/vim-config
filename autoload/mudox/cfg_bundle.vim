if !exists('loaded_cfg_bundle_dot_vim')
    let g:loaded_cfg_bundle_dot_vim = 1
else
    finish
endif

let g:mdx_vimrc_dir                 = g:rc_root . '/vimrc.d'
let g:mdx_bundles_install_dir       = g:rc_root . '/neobundle'
let g:mdx_configs_dir               = g:mdx_vimrc_dir . '/configs.d'
let g:mdx_bundles_dir               = g:mdx_vimrc_dir . '/bundles.d'

let g:mdx_available_bundle_managers = ['NeoBundle', 'Pathogen']
let g:mdx_bundle_manager            = 'Pathogen'
let g:mdx_config_sourced            = []  " finally filled and locked in s:ReisgerBundles().
let g:mdx_loaded_bundles            = []  " finally filled and locked in s:ReisgerBundles().
let g:mdx_bundles_to_register       = []  " unlet'ed before vim startup
let g:mdx_bundle_objs               = []  " unlet'ed before vim startup

function s:MergeConfig(cfg_name)
    if empty(g:mdx_config_sourced)
        call add(g:mdx_config_sourced, g:mdx_config_name)
    endif

    " return if ever sourced before return, else record it.
    if index(g:mdx_config_sourced, a:cfg_name) != -1
        return
    else
        call add(g:mdx_config_sourced, a:cfg_name)
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

function g:Register2NeoBundle()
    execute "NeoBundle " . string(g:mdx_bundle.site) . ', ' . string(g:mdx_bundle.neodict)
endfunction

function g:Register2Pathogen()
    " not need to anything.
endfunction

function s:RegisterBundles()
    " FIRST: collect bundles names from cur_config

    " temporary command used in configs.d/* to source sub config files.
    command -nargs=1 MergeConfig  call s:MergeConfig(<q-args>)

    execute "source " . g:mdx_vimrc_dir . '/cur_config'

    call s:CommitBundlesIn(g:mdx_bundles_to_register)
    unlet g:mdx_bundles_to_register

    " THEN: loading bundle meta data from bundles.d/*
    for b in g:mdx_loaded_bundles
        let g:mdx_bundle = {}
        let g:mdx_bundle.neodict = {}
        execute 'source ' . g:mdx_bundles_dir . '/' . b

        call g:Register2{g:mdx_bundle_manager}()

        " collect plugin configuration functions for later executioin.
        call add(g:mdx_bundle_objs, g:mdx_bundle)
        unlet g:mdx_bundle
    endfor

    " lock global variables
    lockvar g:mdx_loaded_bundles
    lockvar g:mdx_config_sourced

    " clean up functions & commands
    delcommand MergeConfig
    delfunction s:MergeConfig
    delfunction s:CommitBundlesIn
    delfunction g:Register2NeoBundle
    delfunction g:Register2Pathogen
endfunction

function s:ParsePlusReg()
    let l:regex_for_github    = 'https://github\.com/[^/]\+/[^/]\+\.git'
    let l:regex_for_bitbucket = 'https://bitbucket\.org/[^/]\+/[^/]\+\%(\.git\)\?'
    let l:url_rexex = l:regex_for_bitbucket . '\|' . l:regex_for_github

    for l:reg in [@", @+, @*, @a]
        let l:url = matchstr(l:reg, l:url_rexex)
        if !empty(l:url)
            break
        endif
    endfor

    " returns an empty string if parsing failed.
    return l:url
endfunction

function mudox#cfg_bundle#LoadBundleConfigs()
    for b in g:mdx_bundle_objs
        call b.config()
    endfor
    unlet g:mdx_bundle_objs
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
endfunction

function mudox#cfg_bundle#PathogenInit()
    filetype off
    filetype plugin indent off

    let g:pathogen_disabled = []
    if has('vim_starting')
        exe 'set runtimepath+=' . escape(g:rc_root, '\ ') . '/neobundle/pathogen'
    endif

    call s:RegisterBundles()
    let g:pathogen_disabled = filter(
                \ mudox#cfg_bundle#BundleListInstalled(),
                \ 'index(g:mdx_loaded_bundles, v:val) == -1'
                \ )

    call pathogen#infect('neobundle/{}')
    call pathogen#infect('bundle/{}')

    syntax enable
    filetype plugin indent on
endfunction

function mudox#cfg_bundle#EditBundle(name)
    let l:file_name = g:mdx_bundles_dir . '/' . a:name
    let l:open_cmd  = mudox#query_open_file#Main() " gvie user chance to cancel.

    if !filereadable(l:file_name)
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
        let l:repo_addr = s:ParsePlusReg()
        if len(l:repo_addr) > 0
            let l:n = match(l:tmpl, 'let g:mdx_bundle.site = " TODO:')
            let l:tmpl[l:n] = substitute(l:tmpl[l:n], '" TODO:.*$', string(l:repo_addr), '')
        endif

        call append(0, l:tmpl)
        normal dd " delete trailling empty line.

        call cursor(1, 1)
        call search("let g:mdx_bundle.site = '.", 'e')
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

function mudox#cfg_bundle#GetBundleManager()
    " load the g:mdx_bundle_manager setting if any in cur_config.
    " throw away any thing else in cur_config at this moment, which will be
    " adopted the next time cur_config got re-read later.

    " let command MergeConfig in config.d/* do nothing
    command -nargs=1 MergeConfig let s:do_nothing = 1 | unlet s:do_nothing

    execute "source " . g:mdx_vimrc_dir . '/cur_config'

    if index(g:mdx_available_bundle_managers, g:mdx_bundle_manager) == -1
        echoerr 'Unrecognized bundle manager "' . g:mdx_bundle_manager . '"'
    endif

    let g:mdx_bundles_to_register = []
    delcommand MergeConfig
endfunction

function mudox#cfg_bundle#BundlesInit()
    call mudox#cfg_bundle#{g:mdx_bundle_manager}Init()
endfunction

function mudox#cfg_bundle#BundleListAvail()
    let l:bundles = glob(g:mdx_bundles_dir . '/*', 1, 1)
    call map(l:bundles, 'fnamemodify(v:val, ":t:r")')
    return l:bundles
endfunction

function mudox#cfg_bundle#ConfigListAvail()
    let l:configs = glob(g:mdx_configs_dir . '/*', 1, 1)
    call map(l:configs, 'fnamemodify(v:val, ":t:r")')
    return l:configs
endfunction

function mudox#cfg_bundle#BundleListInstalled()
    let l:bundles_installed = glob(g:mdx_bundles_install_dir . '/*', 1, 1)
    call map(l:bundles_installed, 'fnamemodify(v:val, ":t:r")')
    return l:bundles_installed
endfunction
