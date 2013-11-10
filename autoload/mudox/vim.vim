" vim: foldmarker=<<<,>>>
if exists("loaded_mdx_autoload_vim_vim") || &cp || version < 700
    finish
endif
let loaded_mdx_autoload_vim_vim = 1

" Todo:
"   * seperate consecutive function definitions with at least one empty line.
function mudox#vim#add_vim_func_fold_marker() "   <<<2
  let [open, close] = split(&foldmarker, ',')

  execute '%s/^function\>.*(\%(.\%("\s*{{{2\)\@!\)*$/& " ' . open . '2/ec'
  execute '%s/^endfunction\s*$/& " ' . close . '2/ec'

  " align folder markers of all level.
  normal ,zaa
endfunction " >>>2
