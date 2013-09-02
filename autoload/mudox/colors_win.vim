call mudox#color_toy_options#Load()

function! s:SetWin()
    " throwaway buffer options
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=hide

    " other settings
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
    topleft vnew __color_toy__

    let l:gt               = has('gui_running') ? 'gui' : 'term'
    let l:opt_list         = g:color_toy_{l:gt}_vim_color_{g:color_toy_mode}_list
    let l:avail_list       = g:color_toy_airline_colors_collected
    let l:avail_in_opt     = filter(copy(l:avail_list), 'index(l:opt_list, v:val) != -1')
    let l:avail_not_in_opt = filter(copy(l:avail_list), 'index(l:opt_list, v:val) == -1')
    let l:not_avail        = filter(copy(l:opt_list), 'index(l:avail_list, v:val) == -1')

    call append(0, g:color_toy_vim_colors_collected)
    call s:SetWin()
endfunction
