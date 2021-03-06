" vim: foldmethod=marker
" =============================================================================
" File:          autoload/ctrlp/awake_plugin.vim
" Description:   Example extension for ctrlp.vim
" =============================================================================

" To load this extension into ctrlp, add this to your vimrc:
"
"     let g:ctrlp_extensions = ['awake_plugin']
"
" Where 'awake_plugin' is the name of the file 'awake_plugin.vim'
"
" For multiple extensions:
"
"     let g:ctrlp_extensions = [
"         \ 'my_extension',
"         \ 'my_other_extension',
"         \ ]

" Load guard

" GUARD {{{1
if exists("s:loaded") || &cp || version < 700
  finish
endif
let s:loaded = 1
" }}}1


" Add this extension's settings to g:ctrlp_ext_vars
"
" Required:
"
" + init: the name of the input function including the brackets and any
"         arguments
"
" + accept: the name of the action function (only the name)
"
" + lname & sname: the long and short names to use for the statusline
"
" + type: the matching type
"   - line : match full line
"   - path : match full line like a file or a directory path
"   - tabs : match until first tab character
"   - tabe : match until last tab character
"
" Optional:
"
" + enter: the name of the function to be called before starting ctrlp
"
" + exit: the name of the function to be called after closing ctrlp
"
" + opts: the name of the option handling function called when initialize
"
" + sort: disable sorting (enabled by default when omitted)
"
" + specinput: enable special inputs '..' and '@cd' (disabled by default)
"
call add(g:ctrlp_ext_vars, {
	\ 'lname': "Get up, you lazy ass!",
	\ 'sname': 'awake',
	\ 'type': 'line',
	\ 'init': 'ctrlp#awake_plugin#init()',
	\ 'accept': 'ctrlp#awake_plugin#accept',
	\ 'specinput': 0,
	\ })


" Provide a list of strings to search in
"
" Return: a Vim's List
"
" NOTE: g:ctrlp_vim_plug_lazily_awake_plugins here is used for plugin setting
" lines to register their plugins as lazily loaded. it has following
" structure:
" g:ctrlp_vim_plug_lazily_awake_plugins = {
"   '<plugin names>' : {
"     'loaded' : <1 or 0 denoting whether it is be loaded> ,
"     'do' : <command to load the plugin>,
"   }
"   ...
" }
" call ctrlp#vim_plug_lazy_plugins#register(name, do) to register plugins into
" them.
function! ctrlp#awake_plugin#init()
	let plugins_to_load = keys(filter(
        \ copy(g:ctrlp_vim_plug_lazily_awake_plugins), 'v:val["loaded"] != 1'))

  if empty(plugins_to_load)
    return ['** all sleeping plugin are awaken **']
  endif

  return plugins_to_load
endfunction


" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#awake_plugin#accept(mode, str)
  call ctrlp#exit()
  if a:str !=# '** all sleeping plugin are awaken **'
    echohl WarningMsg | echo printf("loading [%s]...", a:str) | echohl None
    let do = g:ctrlp_vim_plug_lazily_awake_plugins[a:str].do
    execute do
    let g:ctrlp_vim_plug_lazily_awake_plugins[a:str].loaded = 1
  endif
endfunction


" (optional) Do something before enterting ctrlp
"function! ctrlp#awake_plugin#enter()
"endfunction


" (optional) Do something after exiting ctrlp
"function! ctrlp#awake_plugin#exit()
"endfunction


" (optional) Set or check for user options specific to this extension
"function! ctrlp#awake_plugin#opts()
"endfunction


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#awake_plugin#id()
	return s:id
endfunction


" Create a command to directly call the new search type
"
" Put this in vimrc or plugin/awake_plugin.vim
" command! CtrlPAwakePlugin call ctrlp#init(ctrlp#awake_plugin#id())

" vim:nofen:fdl=0:ts=2:sw=2:sts=2
