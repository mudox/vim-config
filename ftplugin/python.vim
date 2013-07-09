if has('win32') || has('win64')
    function! s:Py3Run( args )
        w
        lcd %:p:h

        let l:python3_path = 'E:\\PYF\\SDK\\Python3\\py3.exe'

        let l:exeString = l:python3_path . ' ' . expand('%') . ' ' . a:args

        echohl Underlined
        echo l:exeString
        echohl NONE

        echo vimproc#system2(l:exeString)
    endfunction

    command! -nargs=* Pr call s:Py3Run(<q-args>)

elseif has('unix')
    command! -nargs=* Pr exe 'VimProcBang python3 ' . expand('%:p') . ' ' . <q-args>
elseif has('mac') || has('macunix')
    command! -nargs=* Pr exe 'VimProcBang python3 ' . expand('%:p') . ' ' . <q-args>
else
    echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
endif
