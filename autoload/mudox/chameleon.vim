if exists("loaded_mdx_chameleon_vim") || &cp || version < 700
    finish
endif
let loaded_mdx_chameleon_vim = 1

let s:Man                 = {}

" supported vim bundle managers.
" since they have method function to be defined, they must be initialized
" outside of functions
let s:Man.vundle          = {}
let s:Man.pathogen        = {}
let s:Man.neobundle       = {}

" s:Man -- the core object            {{{1

function s:Man.init() dict "             {{{2

  " constants                      {{{3
  let s:Man.man_dir         = g:rc_root . '/vimrc.d'
  lockvar s:Man.man_dir

  let s:Man.repo_dir        = g:rc_root . '/neobundle'
  lockvar s:Man.repo_dir

  let s:Man.metas_dir       = s:Man.man_dir . '/metas.d'
  lockvar s:Man.metas_dir

  let s:Man.modes_dir       = s:Man.man_dir . '/modes.d'
  lockvar s:Man.modes_dir

  let s:Man.globals_dir     = s:Man.man_dir . '/globals.d'
  lockvar s:Man.globals_dir

  let s:Man.manager_avail   = ['Pathogen', 'NeoBundle']
  lockvar s:Man.manager_avail
  "}}}3

  " variables                      {{{3
  " they will be changed in later initialization

  let s:Man.manager         = self.neobundle
  let s:Man.title           = ''
  let s:Man.mode_set        = [] " names of sourced modes.d/* files.
  let s:Man.modes_duplicate = []
  let s:Man.meta_set        = [] " names of sourced metas.d/* files.
  let s:Man.metas_duplicate = []
  let s:Man.metas           = [] " list of bundle meta dicts.
  let s:Man.tree            = {} " dict to hold config & bundle hierarchy.
  "}}}3

  call s:Man.loadMode()
endfunction " }}}2

function s:Man.modeName() dict "         {{{2
  " check if the appropriate environment variable has valid value.

  if !exists('$MDX_CONFIG_NAME')
    throw '$MDX_CONFIG_NAME does not exists.'
  elseif index(self.modesAvail(), $MDX_CONFIG_NAME) == -1
    throw '$MDX_CONFIG_NAME should be set to a valid manager name: ' .
          \ string(self.modesAvail())
  endif

  return $MDX_CONFIG_NAME
endfunction " }}}2

function s:Man.addMetas(list) dict "     {{{2
  " make sure bundle list item be properly initialized.
  let self.tree_ptr.bundles = get(self.tree_ptr, 'bundles', [])

  if empty(a:list) | return | endif

  for name in a:list

    " check bundle name's validity.
    if index(self.metasAvail(), name) == -1
      throw printf("Invalid bundle name: %s", name)
    endif

    " add unique bundle names to current tree.bundles set.
    if index(self.tree_ptr.bundles, name) == -1
      call add(self.tree_ptr.bundles, name)
    endif

    " add unique bundle names to the centralized set.
    if index(self.meta_set, name) == -1
      call add(self.meta_set, name)
    else
      call add(self.metas_duplicate, name)
    endif
  endfor
endfunction " }}}2

function s:Man.mergeModes(list) dict "   {{{2
  for name in a:list
    " check cyclic or duplicate merging.
    if index(self.mode_set, name) != -1
      call add(self.modes_duplicate, name)
      return
    else
      call add(self.mode_set, name)
    endif

    " make sure sub-tree item is properly initialized.
    let self.tree_ptr[name] = get(self.tree_ptr, name,
          \ { 'bundles' : []})

    let old_ptr = self.tree_ptr
    let self.tree_ptr = self.tree_ptr[name]

    " submerge.
    execute 'source ' . self.modes_dir . '/' . name

    let self.tree_ptr = old_ptr
  endfor
endfunction " }}}2

function s:Man.loadMode() dict "         {{{2
  " parse mode files, and fill self.tree, self.meta_set, self.mode_set.
  " all jobs done by the 4 temporary global functions below.

  " temporary pointer tracing current sub tree during traversal.
  let self.tree_ptr = self.tree

  execute 'source ' . self.modes_dir . '/' . self.modeName()

  lockvar  self.title
  lockvar  self.manager
  lockvar! self.tree
  lockvar  self.meta_set
  lockvar  self.metas_duplicate
  lockvar  self.mode_set
  lockvar  self.modes_duplicate

  " clean up functions & commands
  delfunction AddBundles
  delfunction MergeConfigs
  delfunction SetTitle
  delfunction SetBundleManager
  unlet self.tree_ptr
endfunction " }}}2

function s:Man.managerInit() dict "      {{{2
  call self.manager.init()
endfunction " }}}2

function s:Man.loadMetas() dict "        {{{2
  for name in self.meta_set
    let g:mdx_bundle = {}
    let g:mdx_bundle.neodict = {}
    execute 'source ' . self.metas_dir . '/' . name

    call add(self.metas, g:mdx_bundle)

    unlet g:mdx_bundle
  endfor
endfunction " }}}2

function s:Man.metasAvail() dict "       {{{2
  let bundles = glob(self.metas_dir . '/*', 1, 1)
  call map(bundles, 'fnamemodify(v:val, ":t:r")')
  return bundles
endfunction " }}}2

function s:Man.modesAvail() dict "       {{{2
  let configs = glob(self.modes_dir . '/*', 1, 1)
  call map(configs, 'fnamemodify(v:val, ":t:r")')
  return configs
endfunction " }}}2

function s:Man.repoAvail() dict "        {{{2
  let bundles_installed = glob(self.repo_dir . '/*', 1, 1)
  call map(bundles_installed, 'fnamemodify(v:val, ":t:r")')
  return bundles_installed
endfunction " }}}2

function s:Man.neobundle.init() dict "   {{{2
  set nocompatible                " Recommend

  if has('vim_starting')
    exe 'set runtimepath+=' . escape(g:rc_root, '\ ') . '/neobundle/neobundle'
  endif

  call neobundle#rc(g:vim_config_root . '/neobundle')

  " Let neobundle manage neobundle
  NeoBundleFetch 'Shougo/neobundle.vim' , { 'name' : 'neobundle' }

  execute 'NeoBundleLocal ' . escape(g:rc_root, '\ ') . '/bundle'

  " * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  "for meta in s:Man.metas
  "execute "NeoBundle " . string(meta.site)
  "\ . ', ' . string(meta.neodict)
  "endfor
  " * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

  filetype plugin indent on       " Required!

  " Installation check.
  NeoBundleCheck

  if !has('vim_starting')
    " Call on_source hook when reloading .vimrc.
    call neobundle#call_hook('on_source')
  endif

  " mapping \neo to update and show update log.
  nnoremap \neo <Esc>:NeoBundleUpdate<CR>:NeoBundleUpdatesLog<CR>
endfunction " }}}2

function s:Man.pathogen.init() dict "    {{{2
  filetype off
  filetype plugin indent off

  let g:pathogen_disabled = []
  if has('vim_starting')
    exe 'set runtimepath+=' . escape(g:rc_root, '\ ') . '/neobundle/pathogen'
  endif

  " exclude those bundles not listed in loaded configs.d/* files.
  let g:pathogen_disabled = filter(
        \ mudox#cfg_bundle#BundleListInstalled(),
        \ 'index(self.meta_set, v:val) == -1'
        \ )

  call pathogen#infect('neobundle/{}')
  call pathogen#infect('bundle/{}') " will be removed in the future.

  syntax enable
  filetype plugin indent on
endfunction " }}}2

" }}}1

" temporary functions                 {{{1

" temporary global functions used in modes.d/* to source sub-mode files.
" since s:Man.loadModes will be called only once on the start, the commands and
" functions are guaranteed to be defined and deleted properly.

function AddBundles(list) "              {{{2
  call s:Man.addMetas(a:list)
endfunction " }}}2

function MergeConfigs(list) "            {{{2
  call s:Man.mergeModes(a:list)
endfunction " }}}2

function SetTitle(name) "                {{{2
  " only top level config file can call this function.
  if !empty(s:Man.title)
    return
  endif

  let s:Man.title = a:name
  lockvar s:Man.title
endfunction " }}}2

function SetBundleManager(name) "        {{{2
  if index(s:Man.manager_avail, a:name) == -1
    throw 'Invalid manager name, need ' . string(s:Man.manager_avail)
  endif

  " only top level config file can call this function.
  if !empty(s:Man.manager)
    return
  endif

  if a:name ==# 'NeoBundle'
    execute 'let s:Man.manager = s:Man.' . tolower(a:name)
  endif

  lockvar s:Man.manager
endfunction " }}}2

"}}}1

" public interfaces                   {{{1

function mudox#chameleon#Init() "        {{{2
  call s:Man.init()
endfunction " }}}2

let g:mdx= s:Man

"}}}1
