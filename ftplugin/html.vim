" vim: foldmethod=marker
" tab
setlocal foldmethod=marker
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab

" beautify html files {{{1
nnoremap <buffer> \ff :call <SID>Beautify()<Cr>

function! <SID>Beautify() " {{{2
  if !executable('js-beautify')
    echoerr 'can not find executable js-beautify.'
  endif

  let view = winsaveview()
  %!js-beautify --type=html --file -
        \ --indent-size=2
  call winrestview(view)
endfunction "  }}}2
" }}}1
