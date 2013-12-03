" tab
setlocal foldmethod=marker
setlocal tabstop=8
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal expandtab

command! -buffer -nargs=* OpenInFirefox call s:OpenInFirefox()
nnoremap <buffer> <Enter>r :OpenInFirefox<Cr>
" put firefox.exe path in PATH environment.
function! s:OpenInFirefox()
    " save & lcd to current python script file path.
    silent write
    lcd %:p:h

    py import OpenHtmlIn
    py OpenHtmlIn.OpenCurHtmlInFirefox()
endfunction
