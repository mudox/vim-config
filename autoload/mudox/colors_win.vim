function! s:SetWin()
    set filetype=

    "throwaway buffer options
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nowrap
    setlocal nonumber
    setlocal nobuflisted
    setlocal nospell

    " clear fold settings
    setlocal foldcolumn=0
    setlocal foldmethod=manual
    setlocal nofoldenable

    " clear insert mode abbreviations
    iabclear <buffer>

    " local mappings.
    nnoremap <buffer> q :close<CR>

    " highlighting.
endfunction

function! mudox#colors_win#Main()
    " create buffer.
    execute mudox#query_open_file#Main() . 'Colors_Toy'
    call s:SetWin()
endfunction
