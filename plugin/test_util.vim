if exists("loaded_vim_plugin_test_util")
  finish
endif
let loaded_vim_plugin_test_util = 1

function DumpDict(dict, ...) "    {{{2
  if type(a:dict) != type({})
    throw 'DumpDcit(dict) needs a dict'
  endif

  if a:0 == 0
    let ident = 0
  elseif a:0 == 1
    let ident = a:1
  else
    throw 'DumpDcit(dict) only needs 1 or 2 arguments'
  endif

  " flatten dict to a list of [k, v].
  let list = []
  for [k, V] in items(a:dict)
    let list = add(list, [k, V])
    unlet V
  endfor

  call sort(list, 'SortbyType')

  " currently assuming t[0] is always string.
  for t in list
    if type(t[1]) == type({}) " dict
      echohl Directory
      call PrintIdent(ident)
      echon t[0] . ':'
      echohl None
      call DumpDict(t[1], ident + 1)
    elseif type(t[1]) == type([]) " list
      call PrintIdent(ident)
      echon t[0] . ':'
      echohl Repeat
      echon string(t[1])
      echohl None
    elseif type(t[1]) == type(function('sort')) " function or method
      call PrintIdent(ident)
      echon t[0] . ' : '
      echohl Function
      echon string(t[1])
      echohl None
    elseif type(t[1]) == type('') " string
      call PrintIdent(ident)
      echon t[0] . ' : '
      echohl String
      echon string(t[1])
      echohl None
    elseif type(t[1]) == type(1) || type(t[1]) == type(1.0) " number
      call PrintIdent(ident)
      echon t[0] . ' : '
      echohl Number
      echon string(t[1])
      echohl None
    endif
  endfor
endfunction " }}}2

function PrintIdent(ident) "      {{{2
  if a:ident > 0
    exe 'echo printf("%' . a:ident * 4 . 's ", "└")'
  else
    echo ''
  endif
endfunction " }}}2

function SortbyType(lhs, rhs) "   {{{2
  return type(a:lhs[1]) - type(a:rhs[1])
endfunction " }}}2

nnoremap <Cr>t1 :call DumpDict(mdx)<Cr>
nnoremap <Cr>t2 :call Test()<Cr>
function Test() " {{{2 "          {{{2
  so ~/Dropbox/cfg_man.vim
  call g:mdx.init()
endfunction " }}}2
