let s:Man                 = {}
let s:Man.man_dir         = g:rc_root . '/vimrc.d'
let s:Man.repo_dir        = g:rc_root . '/neobundle'
let s:Man.bundles_dir     = s:Man.man_dir . '/bundles.d'
let s:Man.configs_dir     = s:Man.man_dir . '/bundles.d'
let s:Man.manager_avail   = ['Pathogen', 'NeoBundle']
let s:Man.default_manager = 'Pathogen'
let s:Man.configs_set     = []
let s:Man.bundles_set     = []
let s:Man.tree            = {}

let g:mdx_bundles_to_register       = []  " unlet'ed before vim startup
let g:mdx_bundle_objs               = []  " unlet'ed before vim startup

" s:Man -- the core object                 {{{1

function s:Man.curManager() dict "            {{{2
  " check if the appropriate environment variable be properly setted.

  if !exists($MDX_BUNDLE_MANAGER)
    throw '$MDX_BUNDLE_MANAGER does not exists.'
  elseif index(self.manager_avail, $MDX_BUNDLE_MANAGER) == -1
    throw '$MDX_BUNDLE_MANAGER should be set to a valid manager name: ' .
          \ string(self.manager_avail)
  endif

endfunction " }}}2

function s:Man.curConfigName() dict "         {{{2
  " check if the appropriate environment variable be properly setted.

  if !exists($MDX_CONFIG_NAME)
    throw '$MDX_CONFIG_NAME does not exists.'
  elseif index(self.manager_avail, $MDX_CONFIG_NAME) == -1
    throw '$MDX_CONFIG_NAME should be set to a valid manager name: ' .
          \ string(self.manager_avail)
  endif

endfunction " }}}2

function s:Man.mergeConfig(par_tree, cur_tree) dict "   {{{2
  if empty(self.configs_set)
    call add(self.configs_set, g:mdx_config_name)
  endif

  " return if ever sourced before return, else record it.
  if index(self.configs_set, a:par_tree, cur_tree) != -1
    return
  else
    call add(self.configs_set, a:par_tree, cur_tree)
  endif

  call s:enrollBundle(g:mdx_bundles_to_register)
  let g:mdx_bundles_to_register = []

  execute 'source ' . g:mdx_configs_dir . '/' . a:par_tree, cur_tree
  call s:enrollBundle(g:mdx_bundles_to_register)
endfunction " }}}2

function s:Man.enrollBundles(lst) dict "       {{{2
  for b in a:lst
    if index(self.bundles_enrolled, b) == -1
      call add(self.bundles_enrolled, b)
    endif
  endfor
endfunction " }}}2

function s:Man.buildTree() dict "       {{{2
  " temporary command used in configs.d/* to source sub config files.
  " since s:Man.buidTree will be called only once in the start, the command
  " are guaranteed to be defined and deleted only once.
  command -nargs=1 MergeConfig  call self.mergeConfig(self.tree, <q-args>)

  call self.enrollBundles(g:mdx_bundles_to_register)
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
  unlet g:mdx_bundles_to_register
endfunction " }}}2

function s:Man.bundlesConfigured() dict "     {{{2
  let bundles = glob(self.bundles_dir . '/*', 1, 1)
  call map(bundles, 'fnamemodify(v:val, ":t:r")')
  return bundles
endfunction " }}}2

function s:Man.configsAvail() dict "          {{{2
  let configs = glob(self.configs_dir . '/*', 1, 1)
  call map(configs, 'fnamemodify(v:val, ":t:r")')
  return configs
endfunction " }}}2

function s:Man.bundlesInstalled() dict "      {{{2
  let bundles_installed = glob(self.repo_dir . '/*', 1, 1)
  call map(bundles_installed, 'fnamemodify(v:val, ":t:r")')
  return bundles_installed
endfunction " }}}2

"}}}1

" public interfaces                        {{{1

function g:GetBundleManager() "               {{{2
  return self.curManager()
endfunction " }}}2

" }}}1
