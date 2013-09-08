function! s:LuaRun( args )
    " save & lcd to current python script file path.
    w
    lcd %:p:h

    if has('win32') || has('win64')
            let l:lua_interp = 'lua'
            let l:cur_file = substitute(expand('%'), '\\', '/', 'g')
            let l:cur_file = substitute(expand('%'), ' ', '\\ ', 'g')
            let l:exeString = l:lua_interp . ' ' . l:cur_file . ' ' . a:args
    elseif has('unix')
            let l:lua_interp = 'lua'
            let l:exeString = l:lua_interp . ' ' . expand('%') . ' ' . a:args
    elseif has('mac') || has('macunix')
            let l:lua_interp = 'lua'
            let l:exeString = l:lua_interp . ' ' . expand('%') . ' ' . a:args
    else
        echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
    endif

    echohl Underlined | echo l:exeString | echohl NONE

    echo vimproc#system2(l:exeString)
endfunction

command! -buffer -nargs=* Run call s:LuaRun(<q-args>) 
command! -buffer -nargs=* LuaRunWithArgs call s:LuaRun(<q-args>) 

nnoremap <buffer> <leader><leader>r :LuaRunWithArgs<Space>