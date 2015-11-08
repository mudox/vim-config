" Tab
setlocal foldmethod=syntax
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal noexpandtab

nnoremap <buffer> <BS>r <ESC>:w<CR>:!bash %<CR>
function! s:BashRun( args )
  " save & lcd to current python script file path.
  silent write
  lcd %:p:h

  if has('win32') || has('win64')
    echorr 'Oops, not implemented!'
    "let bash_path = 'E:/PYF/SDK/bash/python.exe'
    "let exeString = bash_path . ' ' . escape(expand('%'), ' \') . ' ' . a:args
  elseif has('unix')
    let bash_path = 'bash'
    let exeString = bash_path . ' ' . escape(expand('%'), ' \') . ' ' . a:args
  elseif has('mac') || has('macunix')
    echorr 'Oops, not implemented!'
    "let bash_path = 'bash'
    "let exeString = bash_path . ' ' . escape(expand('%'), ' \') . ' ' . a:args
  else
    echoerr "Oops! Unknown sysinfo"
  endif

  echohl Underlined | echo exeString | echohl NONE

  echo vimproc#system2(exeString)
endfunction

command! -buffer -nargs=* Run call s:BashRun(<q-args>)
command! -buffer -nargs=* BashRunWithArgs call s:BashRun(<q-args>)

nnoremap <buffer> <BS>r :BashRunWithArgs<Space>
