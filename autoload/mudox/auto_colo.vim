" Author: Mudox
" Description: A funny toy for play with vim colorschemes.

if exists('g:loaded_colors_funny_toy')
    finish
endif

let g:loaded_colors_funny_toy = 1

" Initialize g:color_toy_incandidates.
let g:color_toy_incandidates = split(globpath(&rtp, 'colors/*.vim', 1), '\n')
call map(g:color_toy_incandidates, 'fnamemodify(v:val, ":t:r")')

if has("gui_running")
    " White list takes precedence over black list.
    if exists('g:mdx_colos_white_list') &&
                \ !empty('g:mdx_colos_white_list')
        let g:my_colos = filter(
                    \   copy(g:color_toy_incandidates),
                    \   'index(g:mdx_colos_white_list, v:val) != -1'
                    \ )
    elseif exists('g:mdx_colos_black_list') &&
                \ !empty('g:mdx_colos_black_list')
        let g:my_colos = filter(
                    \   copy(g:color_toy_incandidates),
                    \   'index(g:mdx_colos_black_list, v:val) == -1'
                    \ )
    endif
else
    " White list takes precedence over black list.
    if exists('g:mdx_colos_256_white_list') &&
                \ !empty('g:mdx_colos_256_white_list')
        let g:my_colos = filter(
                    \   copy(g:color_toy_incandidates),
                    \   'index(g:mdx_colos_256_white_list, v:val) != -1'
                    \ )
    elseif exists('g:mdx_colos_256_black_list') &&
                \ !empty('g:mdx_colos_256_black_list')
        let g:my_colos = filter(
                    \   copy(g:color_toy_incandidates),
                    \   'index(g:mdx_colos_256_black_list, v:val) == -1'
                    \ )
    endif
endif


function! mudox#auto_colo#AutoColoByDay()
    let today = strftime("%d", localtime()) + 0
    let idx = today % len(g:color_toy_incandidates)
    execute "colorscheme " . g:color_toy_incandidates[idx]
endfunction


function! mudox#auto_colo#AutoColoRandom()
    let idx = localtime() % len(g:color_toy_incandidates)
    execute "colorscheme " . g:color_toy_incandidates[idx]
endfunction

function! mudox#auto_colo#ColoMarquee()
    for c in g:color_toy_incandidates
        execute "colorscheme " . c
        redraw
        echo c
        sleep 300m
    endfor
endfunction

" vim: fileformat=unix
