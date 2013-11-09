if exists("loaded_mdx_chameleon_vim") || &cp || version < 700
  finish
endif
let loaded_mdx_chameleon_vim = 1

let s:Cham                 = {}

" supported vim bundle managers.
" since they have method function to be defined, they must be initialized
" outside of functions.
let s:Cham.vundle          = { 'name' : 'Vundle'   }
let s:Cham.pathogen        = { 'name' : 'Pathogen' }
let s:Cham.neobundle       = { 'name' : 'NeoBundle'}

" s:Cham -- the core object                {{{1

function s:Cham.init() dict "                 {{{2

  " constants                       {{{3
  let self.man_dir         = g:rc_root . '/vimrc.d'
  lockvar self.man_dir

  let self.repo_dir        = g:rc_root . '/neobundle'
  lockvar self.repo_dir

  let self.metas_dir       = self.man_dir . '/metas.d'
  lockvar self.metas_dir

  let self.modes_dir       = self.man_dir . '/modes.d'
  lockvar self.modes_dir

  let self.globals_dir     = self.man_dir . '/globals.d'
  lockvar self.globals_dir

  let self.manager_avail   = ['Pathogen', 'NeoBundle']
  lockvar self.manager_avail

  let self.prefix          = ' └ '
  lockvar self.prefix
  "}}}3

  " variables                       {{{3
  " they are all filled and locked in s:Cham.loadMode()

  let self.manager         = self.neobundle " default
  let self.title           = ''
  let self.mode_set        = [] " names of sourced modes.d/* files.
  let self.modes_duplicate = []
  let self.meta_set        = [] " names of sourced metas.d/* files.
  let self.metas_duplicate = []

  " dict to hold config & bundle hierarchy.
  " will fild and locked in self.loadMode()
  let self.tree            = { 'metas' : [], 'modes' : {} }

  " it will filed and locked in self.loadMetas()
  " and unleted in self.manager.init() after registering.
  let self.metas           = [] " list of plugin meta dicts.
  "}}}3

  call self.loadMode()
  call self.loadMetas()
  call self.manager.init()
  call self.initBundles()
endfunction " }}}2

function s:Cham.modeName() dict "             {{{2
  " check if the appropriate environment variable has valid value.

  if !exists('$MDX_MODE_NAME')
    throw '$MDX_MODE_NAME does not exists.'
  elseif index(self.modesAvail(), $MDX_MODE_NAME) == -1
    throw '$MDX_MODE_NAME should be set to a valid manager name: ' .
          \ string(self.modesAvail())
  endif

  return $MDX_MODE_NAME
endfunction " }}}2

function s:Cham.addMetas(list) dict "         {{{2
  " make sure bundle list item be properly initialized.
  let self.tree_ptr.metas = get(self.tree_ptr, 'metas', [])

  if empty(a:list) | return | endif

  for name in a:list

    " check meta name's validity.
    if index(self.metasAvail(), name) == -1
      throw printf("Invalid meta name: %s", name)
    endif

    " add unique meta names to current tree.metas set.
    if index(self.tree_ptr.metas, name) == -1
      call add(self.tree_ptr.metas, name)
    endif

    " add unique meta names to the centralized set.
    if index(self.meta_set, name) == -1
      call add(self.meta_set, name)
    else
      call add(self.metas_duplicate, name)
    endif
  endfor
endfunction " }}}2

function s:Cham.mergeModes(list) dict "       {{{2
  for name in a:list
    " check cyclic or duplicate merging.
    if index(self.mode_set, name) != -1
      call add(self.modes_duplicate, name)
      return
    else
      call add(self.mode_set, name)
    endif

    " make sure sub-tree item is properly initialized.
    let self.tree_ptr.modes[name] = get(self.tree_ptr.modes, name,
          \ { 'metas' : [], 'modes' : {} })

    let old_ptr = self.tree_ptr
    let self.tree_ptr = self.tree_ptr.modes[name]

    " submerge.
    execute 'source ' . self.modes_dir . '/' . name

    call sort(self.tree_ptr.metas)
    let self.tree_ptr = old_ptr
  endfor
endfunction " }}}2

function s:Cham.loadMode() dict "             {{{2
  " parse mode files, and fill self.tree, self.meta_set, self.mode_set ...
  " virtually, all jobs done by the 4 temporary global functions below.

  " temporary pointer tracing current sub tree during traversal.
  let self.tree_ptr = self.tree

  execute 'source ' . self.modes_dir . '/' . self.modeName()

  " lock
  lockvar  self.title
  lockvar  self.manager
  lockvar! self.tree

  call sort(self.meta_set)        | lockvar  self.meta_set
  call sort(self.metas_duplicate) | lockvar  self.metas_duplicate
  call sort(self.mode_set)        | lockvar  self.mode_set
  call sort(self.modes_duplicate) | lockvar  self.modes_duplicate

  " clean up functions & commands
  delfunction AddBundles
  delfunction MergeConfigs
  delfunction SetTitle
  delfunction SetBundleManager
  unlet self.tree_ptr
endfunction " }}}2

function s:Cham.loadMetas() dict "            {{{2
  for name in self.meta_set
    let g:this_meta = {}
    let g:this_meta.neodict = {}
    execute 'source ' . self.metas_dir . '/' . name

    call add(self.metas, g:this_meta)

    unlet g:this_meta
  endfor

  lockvar! self.metas
endfunction " }}}2

function s:Cham.initBundles() dict " {{{2
  for meta in self.metas
    call meta.config()
  endfor

  unlock! self.metas
  unlet self.metas
endfunction " }}}2

function s:Cham.metasAvail() dict "           {{{2
  let metas = glob(self.metas_dir . '/*', 1, 1)
  call map(metas, 'fnamemodify(v:val, ":t:r")')
  return metas
endfunction " }}}2

function s:Cham.modesAvail() dict "           {{{2
  let configs = glob(self.modes_dir . '/*', 1, 1)
  call map(configs, 'fnamemodify(v:val, ":t:r")')
  return configs
endfunction " }}}2

function s:Cham.repoAvail() dict "            {{{2
  let metas_installed = glob(self.repo_dir . '/*', 1, 1)
  call map(metas_installed, 'fnamemodify(v:val, ":t:r")')
  return metas_installed
endfunction " }}}2

function s:Cham.neobundle.init() dict "       {{{2
  set nocompatible                " Recommend

  if has('vim_starting')
    exe 'set runtimepath+=' . escape(g:rc_root, '\ ') . '/neobundle/neobundle'
  endif

  call neobundle#rc(g:vim_config_root . '/neobundle')

  " Let neobundle manage neobundle
  NeoBundleFetch 'Shougo/neobundle.vim' , { 'name' : 'neobundle' }

  execute 'NeoBundleLocal ' . escape(g:rc_root, '\ ') . '/bundle'

  " * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  for meta in s:Cham.metas
  execute "NeoBundle " . string(meta.site)
  \ . ', ' . string(meta.neodict)
  endfor
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

function s:Cham.pathogen.init() dict "        {{{2
  filetype off
  filetype plugin indent off

  let g:pathogen_disabled = []
  if has('vim_starting')
    exe 'set runtimepath+=' . escape(g:rc_root, '\ ') . '/neobundle/pathogen'
  endif

  " exclude those metas not listed in loaded modes.d/* files.
  let g:pathogen_disabled = filter(
        \ self.metasAvail(), 'index(self.meta_set, v:val) == -1'
        \ )

  call pathogen#infect('neobundle/{}')
  call pathogen#infect('bundle/{}') " will be removed in the future.

  syntax enable
  filetype plugin indent on
endfunction " }}}2

function s:Cham.info() dict "                 {{{2
  echohl Title
  echon printf("%-20s: ", 'Mode')
  echohl Identifier
  echon printf("%s\n", self.modeName())

  echohl Title
  echon printf("%-20s: ", 'Manager')
  echohl Identifier
  echon printf("%s\n", self.manager.name)

  echohl Title
  echon printf("%-20s: ", 'Mode Files')
  echohl Identifier
  echon printf("%s\n", join(self.mode_set, ', '))

  echohl Number
  echon printf("%-3d ", len(self.meta_set))
  echohl Title
  echon printf("%-16s:\n", "Meta Files")

  echohl Delimiter
  echo '-'
  for n in range(&columns - 2) | echon '-' | endfor

  call self.dumpTree(self.tree, ['.'])

  " must have.
  echohl None
endfunction "}}}2

function s:Cham.dumpTree(dict, path) dict "   {{{2
  " arg path: a list record recursion path.

  let max_width = max(map(self.meta_set[:], 'len(v:val)')) + 2
  let fields = (&columns - len(self.prefix)) / max_width

  " print tree path.
  echohl Title
  echo join(a:path, '/') . ':'

  " print meta list.
  echohl Special

  if empty(a:dict.metas)
    echo self.prefix . 'nothing ...'
  else
    for i in range(len(a:dict.metas))
      if i % fields == 0 | echo self.prefix | endif
      execute 'echon printf("%-' . max_width . 's", a:dict.metas[i])'
    endfor
  endif

  " print sub-modes.
  for [name, mode] in items(a:dict.modes)
    call self.dumpTree(mode, add(a:path[:], name))
  endfor

  echohl None
endfunction " }}}2

" }}}1

" temporary functions                    {{{1

" temporary global functions used in modes.d/* to source sub-mode files.
" since s:Cham.loadModes will be called only once on the start, the commands and
" functions are guaranteed to be defined and deleted properly.

function AddBundles(list) "                 {{{2
  call s:Cham.addMetas(a:list)
endfunction " }}}2

function MergeConfigs(list) "               {{{2
  call s:Cham.mergeModes(a:list)
endfunction " }}}2

function SetTitle(name) "                   {{{2
  " only top level config file can call this function.
  if !empty(s:Cham.title)
    return
  endif

  let s:Cham.title = a:name
  lockvar s:Cham.title
endfunction " }}}2

function SetBundleManager(name) "           {{{2
  if index(s:Cham.manager_avail, a:name) == -1
    throw 'Invalid manager name, need ' . string(s:Cham.manager_avail)
  endif

  " only top level config file can call this function.
  if !empty(s:Cham.manager)
    return
  endif

  if a:name ==# 'NeoBundle'
    execute 'let s:Cham.manager = s:Cham.' . tolower(a:name)
  endif

  lockvar s:Cham.manager
endfunction " }}}2

"}}}1

" public interfaces                      {{{1

function mudox#chameleon#Init() "           {{{2
  call s:Cham.init()
endfunction " }}}2

command -nargs=0 ChamInfo call mudox#chameleon#Info()
function mudox#chameleon#Info() " {{{2
  call s:Cham.info()
endfunction " }}}2

let g:mdx= s:Cham

"}}}1
