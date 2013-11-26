if exists("loaded_mdx_autoload_mudox_util_trim_vim") || &cp || version < 700
    finish
endif
let loaded_mdx_autoload_mudox_util_trim_vim = 1

function mudox#util#trim#tail_empty_lines() " {{{2
  %substitute/\m\(\n\s*\)\+\%$//e
endfunction " }}}2

function mudox#util#trim#head_empty_lines() " {{{2
  %substitute/\m\%^\(\n\s*\)\+//e
endfunction " }}}2

function mudox#util#trim#head_tail_empty_lines() " {{{2
  call mudox#util#trim#head_empty_lines()
  call mudox#util#trim#tail_empty_lines()
endfunction " }}}2
