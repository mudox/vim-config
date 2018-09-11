" vim: foldmethod=marker

setlocal foldmethod=marker
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab

function! <SID>formatCodeByJQ()
  if !executable('jq')
    echoerr "need `jq`, try `brew install jq` to install it."
    return
  endif

  let savedView = winsaveview()
  %!jq '.'
  call winrestview(savedView)
endfunction

nnoremap <buffer> \af :<C-U><C-U>silent! call <SID>formatCodeByJQ()<Cr>
