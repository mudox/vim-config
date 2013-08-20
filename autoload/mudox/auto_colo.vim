" Author: Mudox
" Description: A funny toy for play with vim colorschemes.

if exists('g:loaded_colors_funny_toy')
    finish
endif

let g:loaded_colors_funny_toy = 1

" collect vim colorscheme files.
let g:color_toy_vim_colors_collected = split(globpath(&rtp, 'colors/*.vim', 1), '\n')
call map(g:color_toy_vim_colors_collected, 'fnamemodify(v:val, ":t:r")')

" collect airline colorscheme files, if any.
let g:color_toy_airline_colors_collected = split(globpath(&rtp, 'autoload/airline/themes/*.vim', 1), '\n')
call map(g:color_toy_airline_colors_collected, 'fnamemodify(v:val, ":t:r")')

if has("gui_running")
    " White list takes precedence over black list.
    if exists('g:mdx_colos_white_list') &&
                \ !empty('g:mdx_colos_white_list')
        let g:my_colos = filter(
                    \   copy(g:color_toy_vim_colors_collected),
                    \   'index(g:mdx_colos_white_list, v:val) != -1'
                    \ )
    elseif exists('g:mdx_colos_black_list') &&
                \ !empty('g:mdx_colos_black_list')
        let g:my_colos = filter(
                    \   copy(g:color_toy_vim_colors_collected),
                    \   'index(g:mdx_colos_black_list, v:val) == -1'
                    \ )
    endif
else
    " White list takes precedence over black list.
    if exists('g:mdx_colos_256_white_list') &&
                \ !empty('g:mdx_colos_256_white_list')
        let g:my_colos = filter(
                    \   copy(g:color_toy_vim_colors_collected),
                    \   'index(g:mdx_colos_256_white_list, v:val) != -1'
                    \ )
    elseif exists('g:mdx_colos_256_black_list') &&
                \ !empty('g:mdx_colos_256_black_list')
        let g:my_colos = filter(
                    \   copy(g:color_toy_vim_colors_collected),
                    \   'index(g:mdx_colos_256_black_list, v:val) == -1'
                    \ )
    endif
endif


function! mudox#auto_colo#AutoColoByDay()
    let l:today = strftime("%d", localtime()) + 0
    let l:idx = l:today % len(g:color_toy_vim_colors_collected)
    let g:the_vim_color = g:color_toy_vim_colors_collected[l:idx]

    if len(g:color_toy_vim_colors_collected) > 0
        if index(g:color_toy_airline_colors_collected, g:the_vim_color) >= 0
            let g:the_airline_color = g:the_vim_color
        else
            let l:idx = l:today % len(g:color_toy_airline_colors_collected)
            let g:the_airline_color = g:color_toy_airline_colors_collected[l:idx]
        endif
        let g:airline_theme = g:the_airline_color
    endif
endfunction


function! mudox#auto_colo#AutoColoRandom()
    let l:idx = localtime() % len(g:color_toy_vim_colors_collected)
    let g:the_vim_color = g:color_toy_vim_colors_collected[l:idx]
    execute "colorscheme " . g:the_vim_color

    if len(g:color_toy_vim_colors_collected) > 0
        if index(g:color_toy_airline_colors_collected, g:the_vim_color) >= 0
            let g:the_airline_color = g:the_vim_color
        else
            let l:idx = localtime() % len(g:color_toy_airline_colors_collected)
            let g:the_airline_color = g:color_toy_airline_colors_collected[l:idx]
        endif
        let g:airline_theme = g:the_airline_color
    endif
endfunction

function! mudox#auto_colo#ColoMarquee()
    let l:cur_color = g:colors_name

    for c in g:color_toy_vim_colors_collected
        execute "colorscheme " . c
        redraw
        echo c
        sleep 300m
    endfor

    " restore previous colorscheme.
    execute 'colorscheme ' . l:cur_color
endfunction

" vim: fileformat=unix
