if exists("loaded_mdx_autoload_mudox_query_open_file_vim") || &cp || version < 700
  finish
endif
let loaded_mdx_autoload_mudox_query_open_file_vim = 1

" it only return a vim's open way command, according to user's keypress.
" it will handle <Esc> & <C-C> key pressing properly, by throw an exception.
function! mudox#query_open_file#Main()
  let prompt_long = "[e]dit, [E]edit!" .
        \ " [k]Above, [j]Below, [K]Top, [J]Bottom," .
        \ " [h]Left-Side, [r]Right-Side, [H]Left-Most, [L]Right-Most," .
        \ " [t]Tabnew: "
  let prompt_short = 'Where to open? [EhHlLjJkKt] and ? for help: '

  let openways = {}

  " WARNING: keep the trailing space.
  let openways['k'] = 'aboveleft new'   . "\x20"
  let openways['j'] = 'belowright new'  . "\x20"
  let openways['K'] = 'topleft new'     . "\x20"
  let openways['J'] = 'botright new'    . "\x20"
  let openways['h'] = 'aboveleft vnew'  . "\x20"
  let openways['l'] = 'belowright vnew' . "\x20"
  let openways['H'] = 'topleft vnew'    . "\x20"
  let openways['L'] = 'botright vnew'   . "\x20"
  let openways['t'] = 'tabnew'          . "\x20"
  let openways['E'] = 'edit!'           . "\x20"
  let openways['e'] = 'edit'            . "\x20"

  while 1
    echohl Special | echon prompt_short | echohl None
    let key = getchar()

    if key == 13 || key == char2nr('e') " Enter or 'e' pressed.
      return openways['e']
    elseif key == 27 || key == 3 " <Esc> or <C-C> pressed.
      throw 'mudox#query_open_file: Canceled'
    elseif index(keys(openways), nr2char(key)) != -1 " other valid key pressed.
      return openways[nr2char(key)]
    else
      echohl ErrorMsg
      echo "Invalid input need [kjKJhlHLt? or enter]\n"
      echohl None
      continue
    endif
  endwhile
endfunction

" without argument, it open a unnamed emtpy buffer.
" without one argument that specifies a file name, it open a named new buffer
" or existing file.
function mudox#query_open_file#New(...)   " {{{2
  if a:0 > 1
    throw "Invalid argument number for mudox#query_open_file#New(),"
          \ . " need 0 or 1 arguments."
  elseif a:0 == 1 && type(a:1) != type('')
    throw "Invalid argument type for mudox#query_open_file#New(),"
          \ . " need a path string."
  endif

  try
    let open_cmd = mudox#query_open_file#Main()
  catch /^mudox#query_open_file: Canceled$/
    echo '* Canceled! *'
    return
  endtry

  if a:0 == 1 " with a path.
    execute open_cmd . "\x20" . a:1
  else " open an unnamed buffer.
    if (open_cmd =~ 'edit') && empty(bufname('%'))
      return
    endif
    execute open_cmd
  endif
endfunction " }}}2
