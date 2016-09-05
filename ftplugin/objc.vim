" vim: foldmethod=marker

" Indent
setlocal cindent
setlocal cinoptions=g0 "indent for public:, protected:, private: in C++ file

" Fold
setlocal foldmethod=syntax

"tab                                                                                   {{{1
setlocal foldmethod=marker
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab
"}}}1

" beautifier                                                                           {{{1
nnoremap <silent> <buffer> \ff :call <SID>Beautify()<Cr>

function! <SID>Beautify()                                                               " {{{2
  if !executable('uncrustify')
    echoerr 'can not find executable uncrustify, quit...'
    return
  endif

  let view = winsaveview()

  " need a extension to make uncrustify work
  silent execute '%!uncrustify -q -c ' . shellescape($MDX_DOT_FILES .
        \ '/')
  call winrestview(view)
  echo 'prettified by uncrustify'
endfunction "  }}}2
" }}}1

"inoremap <buffer> ;; <C-O>A;
