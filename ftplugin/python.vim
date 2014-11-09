" vim: foldmethod=marker

setlocal colorcolumn=80 " PEP8 put a limit a 79

" tab setting according to PEP8 {{{ 1
setlocal foldmethod=syntax
" }}}1

" run buffer {{{1
function! s:Py3Run( args ) " {{{2
  " save & lcd to current python script file path.
  silent write
  lcd %:p:h

  if has('win32') || has('win64')
    let python3_path = 'E:/PYF/SDK/Python3/python.exe'
    let exeString = python3_path . ' ' . escape(expand('%'), ' \') . ' ' . a:args
  elseif has('unix')
    let python3_path = 'python3'
    let exeString = python3_path . ' ' . escape(expand('%'), ' \') . ' ' . a:args
  elseif has('mac') || has('macunix')
    let python3_path = 'python3'
    let exeString = python3_path . ' ' . escape(expand('%'), ' \') . ' ' . a:args
  else
    echoerr "Oops! Unknown sysinfo"
  endif

  echohl Underlined | echo exeString | echohl NONE

  echo vimproc#system2(exeString)
endfunction  " }}}2

command! -buffer -nargs=* Run call s:Py3Run(<q-args>)
command! -buffer -nargs=* Python3RunWithArgs call s:Py3Run(<q-args>)

nnoremap <buffer> <Enter>r :Python3RunWithArgs<Space>
" }}}1

" remap \af to format current buffer by autopep8. {{{1
function! <SID>Autopep8() " {{{2
  if !executable('autopep8')
    echoerr "need <autopep8>, try 'sudo pip install autopep8' to get it."
  endif

  let view = winsaveview()
  %!autopep8 --aggressive --aggressive --experimental --max-line-length 79
        \ --indent-size 4 -
  call winrestview(view)


endfunction "  }}}2

nnoremap <buffer> \fa :call <SID>Autopep8()<Cr>
nnoremap <buffer> \af :call <SID>Autopep8()<Cr>
"}}}1
