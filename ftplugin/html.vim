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

" run buffer {{{1

" that is open it in firefox.
function! <SID>RunBuffer() " {{{2
  " save & lcd to current python script file path.
  silent write

  let file_name = escape(expand('%:p'), ' \')

  py import webbrowser
  py ff = webbrowser.get('firefox')
  execute "py ff.open('file:///" . file_name . "')"

endfunction  " }}}2

command! -buffer -nargs=* RunBuffer call <SID>RunBuffer()
nnoremap <buffer> <Enter>r :RunBuffer<Cr>
" }}}1
