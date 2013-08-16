if !exists("g:alphaValue")
	let g:mdx_vim_alpha = 255
endif

if !exists("g:stepValue")
	let g:mdx_vim_alpha_step = 5
endif

function! trans_win#AlphaStep( alphaDelta )
    let g:mdx_vim_alpha = g:mdx_vim_alpha + a:alphaDelta
    let g:mdx_vim_alpha = max([80, g:mdx_vim_alpha])
    let g:mdx_vim_alpha = min([255, g:mdx_vim_alpha])
    call libcallnr('mdx', 'TransVimWin', g:mdx_vim_alpha)
endfunction

" nnoremap <C-W>> :<C-U>call trans_win#AlphaStep(g:mdx_vim_alpha_step)<CR>
" nnoremap <C-W>< :<C-U>call trans_win#AlphaStep(-g:mdx_vim_alpha_step)<CR>


