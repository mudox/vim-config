if exists("loaded_testing_vim")
    finish
endif
let loaded_testing_vim = 1

" testing"                            {{{1

nnoremap <Cr>t1 :<C-U>call Test()<Cr>
nnoremap <Cr>t2 :<C-U>call DumpDict(g:mdx)<Cr>
nnoremap <Cr>t3 :<C-U>call DumpDict(g:mdx.tree)<Cr>

function Test() "                        {{{2
  let $MDX_CONFIG_NAME = 'n_vim_mode'
  call mudox#chameleon#Init()
endfunction " }}}2

"}}}1
