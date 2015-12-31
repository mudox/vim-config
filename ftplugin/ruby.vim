" ruby filetype setting.

function! s:RubyRun( args )
    " save & lcd to current python script file path.
    silent write
    lcd %:p:h

    if has('win32') || has('win64')
            let l:ruby_path = 'ruby'
            let l:exeString = l:ruby_path . ' ' . escape(expand('%'), ' \') . ' ' . a:args
    elseif has('unix')
            let l:ruby_path = 'ruby'
            let l:exeString = l:ruby_path . ' ' . escape(expand('%'), ' \') . ' ' . a:args
    elseif has('mac') || has('macunix')
            echoerr 'ruby run on Mac OS not implemented!'
    else
        echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
    endif

    echohl Underlined | echo l:exeString | echohl NONE

    echo vimproc#system2(l:exeString)
endfunction

command! -buffer -nargs=* RubyRunWithArgs call s:RubyRun(<q-args>)

"nnoremap <buffer> <BS>r :RubyRunWithArgs<Space>

setlocal softtabstop=2
setlocal shiftwidth=2
