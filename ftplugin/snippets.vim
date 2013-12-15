" tab setting.
setlocal noexpandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

" a polished foldline
function! SnptFoldText()
    let l:preffix    = '^snippet\s\+'
    let l:trigger    = '\(\([[:punct:]]\).\{-}\2\|\S\+\)'
    let l:suffix     = '\%(\s\+\("[^"]*"\).*\)\=$'
    let l:pat        = l:preffix . l:trigger . l:suffix
    let l:firstline  = getline(v:foldstart)
    let l:match_list = matchlist(l:firstline, l:pat)
    let l:foldline   = printf("%-8.8s » %s", l:match_list[1], l:match_list[3])
    return l:foldline
endfunction

setlocal foldtext=SnptFoldText()
setlocal foldenable
