"function! SnptFoldExpr(lnum)
    "if a:lnum == 1
        "let b:InFold = 0
    "endif

    "if getline(a:lnum) =~ '^snippet.*$'
        "let b:InFold = 1
        "return 1
    "elseif getline(a:lnum) =~ '^endsnippet\s*$'
        "let b:InFold = 0
        "return 1
    "else
        "return b:InFold
    "endif

"endfunction

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

"setlocal foldmethod=expr
"setlocal foldexpr=SnptFoldExpr(v:lnum)
setlocal foldtext=SnptFoldText()
setlocal foldenable
