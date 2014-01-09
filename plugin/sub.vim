if exists("loaded_mdx_plugin_sub_vim") || &cp || version < 700
    finish
endif
let loaded_mdx_plugin_sub_vim = 1

nnoremap <C-S> yiw:%s/\C\m\<<C-R>"\>//g<Left><Left>
xnoremap <C-S> y:%s/\C\m<C-R>"//g<Left><Left>
