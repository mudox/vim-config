let s:Man                 = {}

" s:Man -- the core object                    {{{1

function s:Man.init() dict "                     {{{2

  " constants                      {{{3
  let s:Man.man_dir        = g:rc_root . '/vimrc.d'
  let s:Man.repo_dir       = g:rc_root . '/neobundle'
  let s:Man.bundles_dir    = s:Man.man_dir . '/bundles.d'
  "let s:Man.configs_dir   = s:Man.man_dir . '/configs.d'
  let s:Man.configs_dir    = 'f:\Temps\out'  " for testing

  let s:Man.manager_avail  = ['Pathogen', 'NeoBundle']

  lockvar s:Man.man_dir
  lockvar s:Man.repo_dir
  lockvar s:Man.bundles_dir
  lockvar s:Man.configs_dir
  lockvar s:Man.manager_avail
  "}}}3

  " variables                      {{{3
  " they will be changed in later initialization
  let s:Man.bundle_manager = 'Pathogen'
  let s:Man.title          = ''
  let s:Man.config_set     = [] " record sourced configs.d/* files.
  let s:Man.bundle_set     = [] " record sourced bundles.d/* files.
  let s:Man.bundle_configs = [] " list of bundle configuration dicts.
  let s:Man.tree           = {} " dict to hold config & bundle hierarchy.
  "}}}3

  " supported vim bundle managers
  let s:Man.vundle         = {}
  let s:Man.pathogen       = {}
  let s:Man.neobundle      = {}

  call s:Man.loadMode()
endfunction " }}}2

function s:Man.modeName() dict "                 {{{2
  " check if the appropriate environment variable has valid value.

  if !exists('$MDX_CONFIG_NAME')
    throw '$MDX_CONFIG_NAME does not exists.'
  elseif index(self.configsAvail(), $MDX_CONFIG_NAME) == -1
    throw '$MDX_CONFIG_NAME should be set to a valid manager name: ' .
          \ string(self.configsAvail())
  endif

  return $MDX_CONFIG_NAME
endfunction " }}}2

function s:Man.addBundles(list) dict"            {{{2
  " make sure bundle list item be properly initialized.
  let self.tree_ptr.bundles = get(self.tree_ptr, 'bundles', [])

  if empty(a:list) | return | endif

  for name in a:list

    " check bundle name's validity.
    if index(self.bundlesConfigured(), name) == -1
      throw printf("Invalid bundle name: %s", name)
    endif

    " add unique bundle names to current tree.bundles set.
    if index(self.tree_ptr.bundles, name) == -1
      call add(self.tree_ptr.bundles, name)
    endif

    " add unique bundle names to the centralized set.
    if index(self.bundle_set, name) == -1
      call add(self.bundle_set, name)
    endif
  endfor
endfunction " }}}2

function s:Man.mergeConfigs(list) dict "         {{{2
  for name in a:list
    " check cyclic or duplicate merging.
    if index(self.config_set, name) != -1
      return
    else
      call add(self.config_set, name)
    endif

    " make sure sub-tree item is properly initialized.
    let self.tree_ptr[name] = get(self.tree_ptr, name,
          \ { 'bundles' : []})

    let old_ptr = self.tree_ptr
    let self.tree_ptr = self.tree_ptr[name]

    " submerge.
    execute 'source ' . self.configs_dir . '/' . name

    let self.tree_ptr = old_ptr
  endfor
endfunction " }}}2

function s:Man.loadMode() dict "                 {{{2
  " temporary pointer tracing current sub tree during traversal.
  let self.tree_ptr = self.tree

  execute 'source ' . self.configs_dir . '/' . self.modeName()

  " clean up functions & commands
  delfunction AddBundles
  delfunction MergeConfigs
  delfunction SetTitle
  delfunction SetBundleManager
  unlet self.tree_ptr
endfunction " }}}2

function s:Man.loadBundles() dict "              {{{2
  for name in self.bundle_set
    let g:mdx_bundle = {}
    let g:mdx_bundle.neodict = {}
    execute 'source ' . self.bundles_dir . '/' . name

    call add(self.bundle_configs, g:mdx_bundle)

    unlet g:mdx_bundle
  endfor
endfunction " }}}2

function s:Man.bundlesConfigured() dict "        {{{2
  let bundles = glob(self.bundles_dir . '/*', 1, 1)
  call map(bundles, 'fnamemodify(v:val, ":t:r")')
  return bundles
endfunction " }}}2

function s:Man.configsAvail() dict "             {{{2
  let configs = glob(self.configs_dir . '/*', 1, 1)
  call map(configs, 'fnamemodify(v:val, ":t:r")')
  return configs
endfunction " }}}2

function s:Man.bundlesInstalled() dict "         {{{2
  let bundles_installed = glob(self.repo_dir . '/*', 1, 1)
  call map(bundles_installed, 'fnamemodify(v:val, ":t:r")')
  return bundles_installed
endfunction " }}}2

function s:Man.neobundle.init() dict "           {{{2
  set nocompatible                " Recommend

  if has('vim_starting')
    exe 'set runtimepath+=' . escape(g:rc_root, '\ ') . '/neobundle/neobundle'
  endif

  call neobundle#rc(g:vim_config_root . '/neobundle')

  " Let neobundle manage neobundle
  NeoBundleFetch 'Shougo/neobundle.vim' , { 'name' : 'neobundle' }

  execute 'NeoBundleLocal ' . escape(g:rc_root, '\ ') . '/bundle'

  " * * * * * * * * * * * * * * * * * * *
  call self.neobundle.enrollBundles()
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
endfunction " }}}2

function self.neobundle.enrollBundles() dict "   {{{2
  execute "NeoBundle " . string(g:mdx_bundle.site) .
        \ ', ' . string(g:mdx_bundle.neodict)
endfunction " }}}2

function s:Man.pathogen.init() dict "            {{{2
  filetype off
  filetype plugin indent off

  let g:pathogen_disabled = []
  if has('vim_starting')
    exe 'set runtimepath+=' . escape(g:rc_root, '\ ') . '/neobundle/pathogen'
  endif

  " exclude those bundles not listed in loaded configs.d/* files.
  let g:pathogen_disabled = filter(
        \ mudox#cfg_bundle#BundleListInstalled(),
        \ 'index(self.bundle_set, v:val) == -1'
        \ )

  call pathogen#infect('neobundle/{}')
  call pathogen#infect('bundle/{}') " will be removed in the future.

  syntax enable
  filetype plugin indent on
endfunction " }}}2

"}}}1

" temporary functions                         {{{1
" temporary global functions used in configs.d/* to source sub
" config files.
" since s:Man.buidTree will be called only once on the start, the commands
" and functions are guaranteed to be defined and deleted properly.
function AddBundles(list) "                      {{{2
  call s:Man.addBundles(a:list)
endfunction " }}}2

function MergeConfigs(list) "                    {{{2
  call s:Man.mergeConfigs(a:list)
endfunction " }}}2

function SetTitle(name) "                        {{{2
  " only top level config file can call this function.
  if !empty(s:Man.title)
    return
  endif

  let s:Man.title = a:name
  lockvar s:Man.title
endfunction " }}}2

function SetBundleManager(name) "                {{{2
  if index(s:Man.manager_avail, a:name) == -1
    throw 'Invalid manager name, need ' . string(s:Man.manager_avail)
  endif

  " only top level config file can call this function.
  if !empty(s:Man.bundle_manager)
    return
  endif

  let s:Man.bundle_manager = a:name
  lockvar s:Man.bundle_manager
endfunction " }}}2

"}}}1

" public interfaces                           {{{1

function mudox#chameleon#Init() "                {{{2
  s:Man.init()
endfunction " }}}2

function s:bundlesInit() dict"                   {{{2
  call self.{self.bundle_manager}Init()
endfunction " }}}2

"}}}1

" testing"                                    {{{1
let $MDX_CONFIG_NAME = 'n_vim_mode'
let mdx= s:Man
"}}}1
