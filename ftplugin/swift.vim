" vim: foldmethod=marker

"tab                                                                                   {{{1
"setlocal foldmethod=marker
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab
"}}}1

setlocal synmaxcol=300

function! <SID>formatSwiftFile() abort
  let nr = line('.')
  silent %!swiftformat --indent 2
  execute nr
endfunction

nnoremap \af :<C-U><C-U>call <SID>formatSwiftFile()<Cr>
