" tab setting according to PEP8
setlocal foldmethod=syntax
setlocal tabstop=8
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal smarttab
setlocal expandtab

setlocal colorcolumn=80 " PEP8 put a limit a 79

function! s:Py3Run( args )
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
endfunction

command! -buffer -nargs=* Run call s:Py3Run(<q-args>)
command! -buffer -nargs=* Python3RunWithArgs call s:Py3Run(<q-args>)

nnoremap <buffer> <Enter>r :Python3RunWithArgs<Space>
