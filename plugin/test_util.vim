if exists("loaded_vim_plugin_test_util")
    finish
endif
let loaded_vim_plugin_test_util = 1

function DumpDict(dict, ...)
  if type(a:dict) != type({})
    throw 'DumpDcit(dict) needs a dict'
  endif

  if a:0 == 0
    let l:ident = 0
  elseif a:0 == 1
    let l:ident = a:1
  else
    throw 'DumpDcit(dict) only needs 1 or 2 arguments'
  endif

  " flatten dict to a list of [k, v].
  let l:list = []
  for [l:k, l:V] in items(a:dict)
    let l:list = add(l:list, [l:k, l:V])
    unlet l:V
  endfor

  call sort(l:list, 'SortbyType')

  for l:t in l:list
    if type(l:t[1]) == type({})
      echohl Directory
      call PrintIdent(l:ident) 
      echon l:t[0] . ':'
      echohl None
      call DumpDict(l:t[1], l:ident + 1)
    elseif type(l:t[1]) == type(function('sort'))
      echohl Function
      call PrintIdent(l:ident) 
      echon l:t[0] . ' : ' . string(l:t[1])
      echohl None
    elseif type(l:t[1]) == type('')
      echohl String
      call PrintIdent(l:ident) 
      echon l:t[0] . ' : ' . string(l:t[1])
      echohl None
    elseif type(l:t[1]) == type(1)
      echohl Number
      call PrintIdent(l:ident) 
      echon l:t[0] . ' : ' . string(l:t[1])
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

nnoremap <Cr>t : call DumpDict(mdx)<Cr>
