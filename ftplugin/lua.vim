" vim: foldmethod=marker

" tab {{{1
setlocal foldmethod=syntax
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab
" }}}1

" run buffer {{{1

function! s:RunBuffer( args ) " {{{2
  " save & lcd to current python script file path.
  silent write
  lcd %:p:h

  if !executable('lua')
    echoerr 'missing executable "lua"!'
    return
  endif

  let exeString = 'lua ' . escape(expand('%'), ' \') . ' ' . a:args
  echohl Underlined | echo exeString | echohl NONE

  echo vimproc#system2(exeString)
endfunction " }}}2

command! -buffer -nargs=* RunBufferWithArgs call s:RunBuffer(<q-args>)
nnoremap <buffer> <BS>r :RunBufferWithArgs<Space>
" }}}1

