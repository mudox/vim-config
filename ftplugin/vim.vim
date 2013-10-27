setlocal foldmethod=syntax
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab

nnoremap <buffer> <leader><leader>rl <Esc>YY:@"<CR>
nnoremap <buffer> <Enter>r :<C-U>w<CR>:so %<CR>
