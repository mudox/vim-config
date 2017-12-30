" vim: fdm=marker

let g:tit_target = '.2'

function! s:get_target()
  if has_key(b:, 'get_tit_target')
    return b:get_tit_target()
  endif

  if has_key(b:, 'tit_target')
    return b:tit_target
  endif

  if has_key(g:, 'get_tit_target')
    return g:get_tit_target()
  endif

  if has_key(g:, 'tit_target')
    return g:tit_target
  endif
endfunction

function! s:get_keys()
  if has_key(b:, 'get_tit_keys')
    return b:get_tit_keys()
  endif

  if has_key(b:, 'tit_keys')
    return b:tit_keys
  endif

  if has_key(g:, 'get_tit_keys')
    return g:get_tit_keys()
  endif

  if has_key(g:, 'tit_keys')
    return g:tit_keys
  endif
endfunction

function! s:test_in_tmux()

  let keys = s:get_keys()
  let target = s:get_target()

  if empty(keys)
    echohl WarningMsg
    echo 'can no determine the keys to send'
    echohl None
    return
  endif

  if empty(target)
    echohl WarningMsg
    echo 'can not determine the target tmux pane'
    echohl None
    return
  endif

  update!

  execute('silent !tmux send -t ' . target . ' c-c c-c')
  execute('silent !tmux send -t ' . target . ' ' . shellescape(keys) . ' c-m')

endfunction

nnoremap <Space><Space> :<C-u><C-u>call <SID>test_in_tmux()<Cr>
