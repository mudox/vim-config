" tab
setlocal foldmethod=marker
setlocal tabstop=8
setlocal softtabstop=4
setlocal shiftwidth=4
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
