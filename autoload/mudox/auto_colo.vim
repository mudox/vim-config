" Author: Mudox
" Description: Automatically change colorscheme on vim startup.

if exists('g:did_mdx_auto_colo_vim')
    finish
endif

let g:did_mdx_auto_colo_vim = 1

" Initialize s:my_colos.
exe "cd " . g:vim_config_root . "/colors"
pyfile <sfile>:p:h/get_colos.py


if has("gui_running") 
    " White list takes precedence over black list.
    if exists('g:mdx_colos_white_list') && 
                \ !empty('g:mdx_colos_white_list')
        let g:my_colos = filter(
                    \   copy(s:my_colos), 
                    \   'index(g:mdx_colos_white_list, v:val) != -1'
                    \ )
    elseif exists('g:mdx_colos_black_list') && 
                \ !empty('g:mdx_colos_black_list')
        let g:my_colos = filter(
                    \   copy(s:my_colos), 
                    \   'index(g:mdx_colos_black_list, v:val) == -1'
                    \ )
    endif
else
    " White list takes precedence over black list.
    if exists('g:mdx_colos_256_white_list') && 
                \ !empty('g:mdx_colos_256_white_list')
        let g:my_colos = filter(
                    \   copy(s:my_colos), 
                    \   'index(g:mdx_colos_256_white_list, v:val) != -1'
                    \ )
    elseif exists('g:mdx_colos_256_black_list') && 
                \ !empty('g:mdx_colos_256_black_list')
        let g:my_colos = filter(
                    \   copy(s:my_colos), 
                    \   'index(g:mdx_colos_256_black_list, v:val) == -1'
                    \ )
    endif
endif


function! mudox#auto_colo#AutoColoByDay()
    let today = strftime("%d", localtime()) + 0
    let idx = today % len(s:my_colos)
    execute "colorscheme " . s:my_colos[idx]
endfunction


function! mudox#auto_colo#AutoColoRandom()
    let idx = localtime() % len(s:my_colos)
    execute "colorscheme " . s:my_colos[idx]
endfunction

function! mudox#auto_colo#ColoMarquee()
    for c in s:my_colos
        execute "colorscheme " . c
        redraw
        echo c
        sleep 300m
    endfor
endfunction

" vim: fileformat=unix
