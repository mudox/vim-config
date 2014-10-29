" vim: foldmethod=marker
" tab
setlocal foldmethod=syntax
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab

" beautify js files {{{1
nnoremap <buffer> \ff :call <SID>Beautify()<Cr>

function! <SID>Beautify() " {{{2
  if !executable('js-beautify')
    echoerr 'can not find executable js-beautify.'
  endif

  %!js-beautify --type=js --file -
        \ --indent-size=2
endfunction "  }}}2
" }}}1
