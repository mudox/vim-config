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
setlocal foldmethod=marker
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
  if !executable('csscomb')
    echoerr 'can not find executable csscomb, quit...'
    return
  endif

  let view = winsaveview()

  "silent execute '%!js-beautify --type=css --indent-size=2 --file -'

  "if a:align == 1
    "AlignCtrl Irl:g :[^:]\+;\s*$
    "AlignPush
    "g/{\(\_[^{]\)\{-}}/Align :
    "AlignPop
  "endif

  normal! zn
  if !executable('autoprefixer')
    echoerr 'can not find executable *autoprefixer*, proceeds without vendor'
          \ 'prefixing.'
  else
    silent execute '%!autoprefixer'
  endif

  if exists(':TrailerTrim') != 2
    echoerr 'plugin TrailerTrash command *:TrailerTrim* not available,'
          \ 'proceeds without trailing space trim'
  else
    TrailerTrim
  endif


  " need a 'css' extension to make csscomb work
  let tmpfile = escape(tempname() . '.css', ' \')
  silent execute 'write! ' . tmpfile
  silent execute '!csscomb --config ' . $MDX_DOT_FILES . '/csscomb.json ' . tmpfile
  %d " clear whole buffer.
  silent execute 'read ' . tmpfile
  1delete _

  call winrestview(view)
endfunction "  }}}2
" }}}1

" for css properties such as box-shadow, vertical align ...
setlocal iskeyword+=-
