" vim: foldmethod=marker
" tab
setlocal foldmethod=marker
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab

setlocal fileformat=unix

" beautify html files {{{1
nnoremap <buffer> \ff :call <SID>Beautify()<Cr>

function! <SID>Beautify() " {{{2
  if !executable('js-beautify')
    echoerr 'missing executable js-beautify, quit...'
  endif

  let view = winsaveview()
  %!js-beautify --type=html --indent-size=2 --file -
  call winrestview(view)
endfunction "  }}}2
" }}}1

" run buffer {{{1

" that is open it in firefox.
function! <SID>RunBuffer() " {{{2
  " save & lcd to current python script file path.
  silent write

  py import webbrowser
  execute "py webbrowser.open('file:///" . expand('%:p') . "')"

endfunction  " }}}2

command! -buffer -nargs=* RunBuffer call <SID>RunBuffer()
nnoremap <buffer> <BS>r :RunBuffer<Cr>
" }}}1
