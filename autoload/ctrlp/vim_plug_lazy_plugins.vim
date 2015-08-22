" vim: foldmethod=marker

" GUARD {{{1
if exists("s:loaded") || &cp || version < 700
  finish
endif
let s:loaded = 1
" }}}1

let g:ctrlp_vim_plug_lazily_awake_plugins = {}

function! ctrlp#vim_plug_lazy_plugins#register(name, do)
  if has_key(g:ctrlp_vim_plug_lazily_awake_plugins, a:name)
    throw 'ctrlp#loadplugin#reg_plugin(): already registered plugin [' . a:name
          \ . ']'
  endif
  let g:ctrlp_vim_plug_lazily_awake_plugins[a:name] = {
        \   'loaded': 0,
        \   'do': a:do,
        \ }
endfunction
