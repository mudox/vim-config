" go filetype setting.
setlocal foldmethod=syntax
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal smarttab
setlocal noexpandtab

function! s:GoRun( args )
    " save & lcd to current python script file path.
    silent write
    lcd %:p:h

    if has('win32') || has('win64')
            let l:go_path = 'go'
            let l:exeString = l:go_path . ' run ' . escape(expand('%'), ' \') . ' ' . a:args
    elseif has('unix') " also works on Mac OSX
            let l:go_path = 'go'
            let l:exeString = l:go_path . ' run ' . escape(expand('%'), ' \') . ' ' . a:args
    else
        echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
    endif

    echohl Underlined | echo l:exeString | echohl NONE

    let l:old_enc = get(g:, 'stdoutencoding', 'char')
    let g:stdoutencoding = 'utf8'
    echo vimproc#system2(l:exeString)
    let g:stdoutencoding = l:old_enc
endfunction

command! -buffer -nargs=* GoRunWithArgs call s:GoRun(<q-args>)

nnoremap <buffer> <BS>r :GoRunWithArgs<Space>

if executable('goimports')
  let g:gofmt_command = 'goimports'
endif
