if exists("loaded_vim_plugin_test_util")
  finish
endif
let loaded_vim_plugin_test_util = 1

function DumpDict(dict, ...)
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

  for t in list
    if type(t[1]) == type({}) " dict
      echohl Directory
      call PrintIdent(ident)
      echon t[0] . ':'
      echohl None
      call DumpDict(t[1], ident + 1)
    elseif type(t[1]) == type(function('sort')) " function or method
      echohl Function
      call PrintIdent(ident)
      echon t[0] . ' : ' . string(t[1])
      echohl None
    elseif type(t[1]) == type('') " string
      echohl String
      call PrintIdent(ident)
      echon t[0] . ' : ' . string(t[1])
      echohl None
    elseif type(t[1]) == type(1) || type(t[1]) == type(1.0) " number
      echohl Number
      call PrintIdent(ident)
      echon t[0] . ' : ' . string(t[1])
      echohl None
    endif
  endfor
endfunction

function PrintIdent(ident)
  if a:ident > 0
    exe 'echo printf("%' . a:ident * 4 . 's ", "└")'
  else
    echo ''
  endif
endfunction

function SortbyType(lhs, rhs)
  return type(a:lhs[1]) - type(a:rhs[1])
endfunction

nnoremap <Cr>t1 :call DumpDict(mdx)<Cr>
nnoremap <Cr>t2 :call Test()<Cr>
function Test() " {{{2
  so ~/cfg_man.vim
  call g:mdx.init()
endfunction " }}}2
