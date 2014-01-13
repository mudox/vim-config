if exists("loaded_mdx_autoload_mudox_query_open_file_vim") || &cp || version < 700
  finish
endif
let loaded_mdx_autoload_mudox_query_open_file_vim = 1

" Usage: execute mudox#query_open_file#Main() . " " . <YOUR FILE>

function! mudox#query_open_file#Main()
  let promt = "[]Edit," .
        \ " [k]Above, [j]Below, [K]Top, [J]Bottom," .
        \ " [h]Left-Side, [r]Right-Side, [H]Left-Most, [L]Right-Most," .
        \ " [t]Tabnew: "

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

  while 1
    let open = input(promt, 'edit')
    let open = substitute(open, '\s\+', '', 'g') " strip spaces in open

    if open == ''
      return ''
    elseif open =~ '^[jkJKhlHLt]$'
      return openways[open]
    else
      call EchoError("\nInvalid input, need [k,j,K,J,h,l,H,L,t or empty]")
    endif
  endw
endfunction

function mudox#query_open_file#New(...)   " {{{2
  if a:0 > 1
    echoerr 'invalid argument number for mudox#query_open_file#New(), need 0 or 1 arguments.'
    return
  elseif a:0 == 1
    if type(a:1) != type('')
      echoerr 'invalid argument type for mudox#query_open_file#New(), need a path string.'
      return
    endif
  endif

  let open_cmd = mudox#query_open_file#Main()
  if open_cmd == ''
    return
  endif

  if a:0 == 1
    execute open_cmd . " " . a:1
  else
    if (open_cmd =~ 'edit') && empty(bufname('%'))
      return
    endif
    execute open_cmd
  endif
endfunction " }}}2
