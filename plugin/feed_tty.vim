" vim: foldmethod=marker

" GUARD {{{1
if exists("s:loaded") || &cp || version < 700
  finish
endif
let s:loaded = 1
" }}}1

function! <SID>feed_tty() " {{{2
  let cmd_line = input('your command: ')
  let sucker_file_path = '/tmp/mdx_tty_sucker'

  if !filewritable(sucker_file_path)
    echoerr "sucker file not available, open zsh and run 'tusck' first."
    return
  endif

  call writefile([cmd_line], sucker_file_path)
endfunction "  }}}2

nnoremap <BS>t :<C-U>call <SID>feed_tty()<Cr>
