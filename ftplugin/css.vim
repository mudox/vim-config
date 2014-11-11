" vim: foldmethod=marker

" tab                                                                                  {{{1
setlocal foldmethod=marker
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab
" }}}1

" fold                                                                                 {{{1
setlocal foldmethod=syntax
setlocal foldenable

setlocal foldtext=CSSFoldText()
function! CSSFoldText()
  let l:firstline = getline(v:foldstart)
  let l:sub = substitute(l:firstline, '{.*$', '', 'g')
  let l:prefix = '» '
  let l:foldline = l:prefix . l:sub
  return l:foldline
endfunction
" }}}1

" beautifier                                                                           {{{1
nnoremap <buffer> \ff :call <SID>Beautify(0)<Cr>
nnoremap <buffer> \fa :call <SID>Beautify(1)<Cr>

function! <SID>Beautify(align)                                                          " {{{2
  if !executable('js-beautify')
    echoerr 'can not find executable js-beautify.'
  endif

  let view = winsaveview()

  %!js-beautify --type=css --file -
        \ --indent-size=2

  if a:align == 1
    AlignCtrl Irl:g :[^:]\+;\s*$
    AlignPush
    g/{\(\_[^{]\)\{-}}/Align :
    AlignPop
  endif

  call winrestview(view)
endfunction "  }}}2
" }}}1
