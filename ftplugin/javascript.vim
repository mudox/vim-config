" vim: foldmethod=marker
" tab
setlocal foldmethod=syntax
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab

setlocal foldmethod=marker

" run buffer {{{1

function! <SID>RunBuffer( args ) " {{{2
  " save & lcd to current python script file path.
  silent write
  lcd %:p:h

  if !executable('node')
    echoerr 'missing executable "node"!'
    return
  endif

  let exeString = 'node ' . escape(expand('%'), ' \') . ' ' . a:args
  echohl Underlined | echo exeString | echohl NONE

  echo vimproc#system2(exeString)
endfunction  " }}}2

command! -buffer -nargs=* RunBuffer call <SID>RunBuffer(<q-args>)
nnoremap <buffer> <BS>r :RunBuffer<Space>
" }}}1

" insert mode mappings {{{1
inoremap <buffer> ;; <C-O>A;
inoremap <buffer> ,, <C-O>A,
