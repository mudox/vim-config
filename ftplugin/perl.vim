function! s:SimpleRun( args )
    " save & lcd to current python script file path.
    silent write
    lcd %:p:h

    let l:exeString = 'perl ' . escape(expand('%'), '\ ') . ' ' . a:args

    echohl Underlined | echo l:exeString | echohl NONE

    echo vimproc#system2(l:exeString)
endfunction

command! -buffer -nargs=* Run call s:SimpleRun(<q-args>)
command! -buffer -nargs=* SimpleRunWithArgs call s:SimpleRun(<q-args>)

nnoremap <buffer> <leader><leader>r :SimpleRunWithArgs<Space>
