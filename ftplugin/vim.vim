" tab
setlocal foldmethod=marker
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab

" fold
setlocal foldmethod=marker

nnoremap <buffer> <leader><leader>rl <Esc>YY:@"<CR>
nnoremap <buffer> <Enter>r :<C-U>w<CR>:so %<CR>

" syntax hightlighting
let g:vimsyn_embed = 0      " disable all embeding syntax.
let g:vimsyn_noerror = 1
"let g:vimsyn_folding = 'af' " enable autofolding of autogroups & functions.
