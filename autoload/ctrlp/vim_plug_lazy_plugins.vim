if exists('did_vim_plug_lazy_plugins_vim') || &cp || version < 700
  finish
endif
let did_vim_plug_lazy_plugins_vim = 1

let g:ctrlp_vim_plug_lazily_load_plugins = {}

function! ctrlp#vim_plug_lazy_plugins#register(name, do)
  if has_key(g:ctrlp_vim_plug_lazily_load_plugins, a:name)
    throw 'ctrlp#loadplugin#reg_plugin(): already registered plugin [' . a:name
          \ . ']'
  endif
  let g:ctrlp_vim_plug_lazily_load_plugins[a:name] = {
        \   'loaded': 0,
        \   'do': a:do,
        \ }
endfunction
