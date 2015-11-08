" vim: foldmethod=marker

setlocal foldmethod=syntax

" run buffer {{{1
function! s:RunBuffer( args ) " {{{2
  " save & lcd to current python script file path.
  silent write
  lcd %:p:h

  let exeString = 'python ' . escape(expand('%'), ' \') . ' ' . a:args

  echohl Underlined | echo exeString | echohl NONE

  echo vimproc#system2(exeString)
endfunction  " }}}2

command! -buffer -nargs=* Run call s:RunBuffer(<q-args>)
command! -buffer -nargs=* RunWithArgs call s:RunBuffer(<q-args>)

nnoremap <buffer> <BS>r :RunWithArgs<Space>
" }}}1

" remap \af to format current buffer by autopep8. {{{1
function! <SID>Autopep8() " {{{2
  if !executable('autopep8')
    echoerr "need <autopep8>, try 'sudo pip install autopep8' to get it."
  endif

  let view = winsaveview()
  %!autopep8
        \ --aggressive
        \ --aggressive
        \ --experimental
        \ --max-line-length 79
        \ --indent-size 4
        \ -
  call winrestview(view)


endfunction "  }}}2

nnoremap <buffer> \af :call <SID>Autopep8()<Cr>
"}}}1
