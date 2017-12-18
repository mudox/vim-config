" vim: foldmethod=marker

setlocal foldmethod=marker
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab

setlocal foldmethod=marker

function! <SID>formatCodeByAutopep8AndISort()
  if !executable('autopep8')
    echoerr "need `autopep8`, try 'sudo pip install autopep8' to install it."
    return
  endif

  let savedView = winsaveview()
  %!autopep8
        \ -a -a -a
        \ --experimental
        \ --indent-size 2
        \ -
  %!isort -
  call winrestview(savedView)
endfunction



function! <SID>formatCodeByYAPFAndISort()
  if !executable('autopep8')
    echoerr "need `autopep8`, try 'sudo pip install autopep8' to install it."
    return
  endif

  let savedView = winsaveview()
  %!yapf
  %!isort -
  call winrestview(savedView)
endfunction

nnoremap <buffer> \af :<C-U><C-U>silent! call <SID>formatCodeByAutopep8AndISort()<Cr>
