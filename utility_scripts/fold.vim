function! AddFuncFold() " {{{2
  %s/^function\s\+.*$/& " {{{2
  %s/^endfunction\s*$/endfunction " }}}2
  normal ,zaa
endfunction " }}}2
