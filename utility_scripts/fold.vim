" vim: foldmarker=<<<,>>>

" Todo:
"   * honor foldmarker setting.
"   * seperate consecutive function definitions with at least one empty line.
function! AddFuncFold() " <<<2
  %s/^function\>[!]\%(\%("\s*{{{2\)\@!.\)*$/& " {{{2
  %s/^endfunction\s\+\%(\%("\s*{{{2\)\@!.\)*$/& " }}}2
  normal ,zaa
endfunction " >>>2
