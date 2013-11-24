if exists("loaded_testing_vim")
    finish
endif
let loaded_testing_vim = 1

" testing"                            {{{1

nnoremap <Cr>t1 :<C-U>call DumpDict(g:mdx_kaleidoscope)<Cr>
"nnoremap <Cr>t2 :<C-U>call DumpDict(g:mdx)<Cr>
"nnoremap <Cr>t3 :<C-U>call DumpDict(g:mdx.tree)<Cr>

"}}}1
