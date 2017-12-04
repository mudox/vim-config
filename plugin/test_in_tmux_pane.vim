" vim: fdm=marker

function! s:testInTmux()

  let cmd = get(b:, 'tit_cmd', get(g:, 'tit_cmd', ''))
  let target = get(b:, 'tit_target', get(g:, 'tit_target', ''))

  if empty(cmd)
    echohl WarningMsg
    echo 'variable `b:tit_cmd` is missing'
    echohl None
    return
  endif

  if empty(target)
    echohl WarningMsg
    echo 'variable `b:tit_target` is missing'
    echohl None
    return
  endif

  execute('silent !tmux send -t ' . target . ' ' . shellescape(cmd) . ' c-m')

endfunction

nnoremap <Space><Space> :<C-u><C-u>call <SID>testInTmux()<Cr>
