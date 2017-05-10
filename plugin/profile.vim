function! <SID>ToggleProfiling()
  let profDir = '/tmp/mudox/log/vim/'
  let profPath = profDir . 'vim.prof'
  if v:profiling
    profile dump
    profile stop
    call Qpen(profPath)
    normal! G
  else
    call mkdir(profDir, 'p')
    call delete(profPath)
    exe 'profile start ' . profPath
    profile func *
    echo 'profiling to ' . profPath . '...'
  endif
endfunction

nnoremap cop :<C-U><C-U>call <SID>ToggleProfiling()<Cr>
