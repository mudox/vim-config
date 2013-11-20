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
  let self.cham_dir        = g:rc_root . '/vimrc.d'
  lockvar self.cham_dir

  let self.repo_dir        = g:rc_root . '/neobundle'
  lockvar self.repo_dir

  let self.metas_dir       = self.cham_dir . '/metas.d'
  lockvar self.metas_dir

  let self.modes_dir       = self.cham_dir . '/modes.d'
  lockvar self.modes_dir

  let self.globals_dir     = self.cham_dir . '/globals.d'
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

  let name = readfile(self.cham_dir . '/cur_mode')[0]
  if index(self.modesAvail(), name) == -1
    throw 'Invalid mode name in ' . self.cham_dir . '/cur_mode'
  endif

  return name
endfunction " }}}2

function s:Cham.addMetas(list) dict "         {{{2
  " make sure bundle list item be properly initialized.
  let self.tree_ptr.metas = get(self.tree_ptr, 'metas', [])

  if empty(a:list) | return | endif

  for name in a:list

    " check meta name's validity.
    if index(self.metasAvail(), name) == -1
      echoerr printf("Invalid meta name: %s", name)
      break
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

    let g:this_meta.neodict.name = g:this_meta.name

    call add(self.metas, g:this_meta)

    unlet g:this_meta
  endfor

  lockvar! self.metas
endfunction " }}}2

function s:Cham.initBundles() dict "          {{{2
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
  " mode name
  echohl Title
  echon printf("%-14s ", 'Mode:')
  echohl Identifier
  echon printf("%s\n", self.title)

  " mode file name
  echohl Title
  echon printf("%-14s ", 'Mode file:')
  echohl Identifier
  echon printf("%s\n", self.modeName())

  " bundle manager name
  echohl Title
  echon printf("%-14s ", 'Manager:')
  echohl Identifier
  echon printf("%s\n", self.manager.name)

  " long delimiter line.
  echohl Number
  echon printf("%-3d ", len(self.meta_set))
  echohl Title
  echon printf("%-14s ", "Metas Enrolled")

  echohl Delimiter
  echon '-'
  for n in range(&columns - 38) | echon '-' | endfor

  echohl Number
  echon printf(" in %2d ", len(self.mode_set))
  echohl Title
  echon "Mode files"
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

function s:Cham.editMode(arg) dict "          {{{2
  let names = split(a:arg)
  if len(names) > 2
    echoerr 'Too many arguments, at most 2 arguemnts is needed'
    return
  endif

  if len(names) == 0 " Edit current mode.
    let file_path = self.modes_dir . '/' . self.modeName()
    execute mudox#query_open_file#Main() . file_path
  else " edit a new or existing mode.
    let file_path = self.modes_dir . '/' . names[0]

    if filereadable(file_path)
      execute mudox#query_open_file#Main() . file_path
    else
      " gvie user chance to cancel.
      let open_cmd  = mudox#query_open_file#Main()

      " read template content if any.
      let tmpl_path = self.modes_dir . '/'
            \ . (len(names) == 2 ? names[1] : '../mode_template')
      echo tmpl_path

      if filereadable(tmpl_path)
        let tmpl = readfile(tmpl_path)
      else
        echoerr "Template file " . tmpl_path . ' unreadable'
        echoerr "creating an empty mode ..."
      endif

      execute  open_cmd . file_path

      if exists('tmpl')
        setlocal filetype=vim
        setlocal foldmethod=marker
        setlocal fileformat=unix
        call append(0, tmpl)
        normal dd
      endif
    endif
  endif
endfunction " }}}2

function s:Cham.editMeta(name) dict "         {{{2
  let file_name = self.metas_dir . '/' . a:name
  let open_cmd  = mudox#query_open_file#Main() " gvie user chance to cancel.

  if !filereadable(file_name)
    " read template content
    let tmpl = readfile(self.cham_dir . '/meta_template')
  endif

  execute  open_cmd . file_name

  " if it is creating a new meta, fill it with appropriate template.
  if exists('tmpl')
    setlocal filetype=vim
    setlocal foldmethod=marker
    setlocal fileformat=unix

    " fill with template.
    " if register + got a valid git repo address, then automatically
    " insert the shrotened address into appropriate place.
    let repo_addr = self.peekUrl()
    if len(repo_addr) > 0
      let n = match(tmpl, 'let g:this_meta.site = " TODO:')
      let tmpl[n] = substitute(tmpl[n], '" TODO:.*$', string(repo_addr), '')
    endif

    call append(0, tmpl)
    normal dd " delete trailling empty line.

    call cursor(1, 1)
    call search("let g:this_mode.site = '.", 'e')
  endif
endfunction " }}}2

function s:Cham.peekUrl() dict "              {{{2
  " currently only support github & bitbucket address.
  let github_pat    = 'https://github\.com/[^/]\+/[^/]\+\.git'
  let bitbucket_pat = 'https://bitbucket\.org/[^/]\+/[^/]\+\%(\.git\)\?'
  let url_pat = bitbucket_pat . '\|' . github_pat

  for reg in [@", @+, @*, @a]
    let url = matchstr(reg, url_pat)
    if !empty(url)
      break
    endif
  endfor

  " will returns an empty string if parsing failed.
  return url
endfunction " }}}2
" }}}1

" temporary functions                      {{{1

" temporary global functions used in modes.d/* to source sub-mode files.
" since s:Cham.loadModes will be called only once on the start, the commands and
" functions are guaranteed to be defined and deleted properly.

function AddBundles(list) "                   {{{2
  call s:Cham.addMetas(a:list)
endfunction " }}}2

function MergeConfigs(list) "                 {{{2
  call s:Cham.mergeModes(a:list)
endfunction " }}}2

function SetTitle(name) "                     {{{2
  " only top level config file can call this function.
  if !empty(s:Cham.title)
    return
  endif

  let s:Cham.title = a:name
  lockvar s:Cham.title
endfunction " }}}2

function SetBundleManager(name) "             {{{2
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

" public interfaces                        {{{1

function mudox#chameleon#Init() "             {{{2
  call s:Cham.init()
endfunction " }}}2

" :ChamInfo                                   {{{2
command -nargs=0 ChamInfo call mudox#chameleon#Info()
function mudox#chameleon#Info()
  call s:Cham.info()
endfunction
" }}}2

" :EditMeta & <Enter>b                        {{{2
command -nargs=1 -complete=custom,<SID>MetasAvail EditMeta
      \ call s:Cham.editMeta(<q-args>)
nnoremap <Enter>b :EditMeta<Space>

function <SID>MetasAvail(arglead, cmdline, cursorpos)
  return join(s:Cham.metasAvail(), "\n")
endfunction
" }}}2

" :EditMode & <Enter>c                        {{{2
command -nargs=* -complete=custom,<SID>modesAvail EditMode
      \ call s:Cham.editMode(<q-args>)
nnoremap <Enter>c :EditMode<Space>

function <SID>modesAvail(arglead, cmdline, cursorpos)
  return join(s:Cham.modesAvail(), "\n")
endfunction
" }}}2

" autocmd VimEnter                            {{{2
autocmd VimEnter * call <SID>OnVimEnter()

function <SID>OnVimEnter()
  let title = get(s:Cham, 'title', s:Cham.modeName())

  silent set title
  let &titlestring = title
endfunction
" }}}2

let g:mdx = s:Cham
let mudox#chameleon#core = s:Cham

"}}}1
