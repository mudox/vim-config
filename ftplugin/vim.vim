" vim: foldmethod=marker

" tab   {{{1
setlocal foldmethod=marker
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab
" }}}1

setlocal colorcolumn=80

" fold
setlocal foldmethod=syntax

" source current line.
nnoremap <buffer> <leader><leader>cl <Esc>YY:@"<Cr>
" source %
nnoremap <buffer> <BS>r :<C-U>w<Cr>:so %<Cr>

" syntax hightlighting
let g:vimsyn_embed   = 0    " disable all embeding syntax.
let g:vimsyn_noerror = 1
let g:vimsyn_folding = 'af' " enable autofolding of autogroups & functions.
