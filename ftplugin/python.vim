function! s:Py3Run( args )
    " save & lcd to current python script file path.
    w
    lcd %:p:h

    if has('win32') || has('win64')
            let l:python3_path = 'E:/PYF/SDK/Python3/python.exe'
            let l:exeString = l:python3_path . ' ' . expand('%') . ' ' . a:args
    elseif has('unix')
            let l:python3_path = 'python3'
            let l:exeString = l:python3_path . ' ' . expand('%') . ' ' . a:args
    elseif has('mac') || has('macunix')
            let l:python3_path = 'python3'
            let l:exeString = l:python3_path . ' ' . expand('%') . ' ' . a:args
    else
        echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
    endif

    echohl Underlined | echo l:exeString | echohl NONE

    echo vimproc#system2(l:exeString)
endfunction

command! -buffer -nargs=* Run call s:Py3Run(<q-args>)
command! -buffer -nargs=* Python3RunWithArgs call s:Py3Run(<q-args>)

nnoremap <buffer> <Enter>r :Python3RunWithArgs<Space>
