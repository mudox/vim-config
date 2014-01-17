function! s:ScriptLoadingStatusDcit()
    " get the output of ":scriptnames" in the l:scriptnames_output variable.
    let l:scriptnames_output = ''
    redir => l:scriptnames_output
    silent scriptnames
    redir END

    let l:list_of_lines = split(l:scriptnames_output, '\n')

    " strip prefix numbers.
    call map(l:list_of_lines, 'v:val[5:]')

    " only interested in '~/.vim[vimfiles]/neobundle[bundle]/' lines
    call filter(l:list_of_lines, 'v:val =~? ' . "'"
                \ . '\m\c[~][\\/]\%(\.vim\|vimfiles\)[\\/]\%(neobundle\|bundle\)[\\/]'
                \ . "'")
    call sort(l:list_of_lines)

    let l:plugin = ''
    let l:dict_of_scripts = {}

    for l:line in l:list_of_lines
        let l:tmp = matchstr(l:line,
                    \ '\m\c[~][\\/]\%(\.vim\|vimfiles\)[\\/]\%(neobundle\|bundle\)[\\/]\zs[^\\/]\+\ze[\\/]')

        if empty(l:tmp)
            echoerr 'empty string returned from matchstr()'
            echoerr 'l:line: ' . l:line
        endif

        if l:plugin != l:tmp
            let l:plugin = l:tmp
            let l:dict_of_scripts[l:plugin] = []
        endif

        let l:file_line = substitute(l:line, '\m\c^.\{-}\%(neobundle\|bundle\)', '\t', '')
        call add(l:dict_of_scripts[l:plugin], l:file_line)
    endfor

    return l:dict_of_scripts
endfunction

function! s:SPrintScriptLoadingStatus()
    let l:nr_plug = 0
    let l:nr_file = 0
    let l:retStr = ''

    for [l:script, l:files] in items(s:ScriptLoadingStatusDcit())
        let l:nr_plug = l:nr_plug + 1
        let l:nr_file = l:nr_file + len(l:files)
        let l:retStr  = l:retStr . printf("\n\n[%03d] -- %s\n", l:nr_plug, l:script)
        let l:retStr = l:retStr . join(l:files, "\n")
    endfor

    let l:sumStr = ''
    let l:sumStr = l:sumStr . "\n\n-------------------------------------------------------------"
    let l:sumStr = l:sumStr . "\nTotally:"
    let l:sumStr = l:sumStr . printf("\n%5d plugins", l:nr_plug)
    let l:sumStr = l:sumStr . printf("\n%5d files", l:nr_file)
    let l:sumStr = l:sumStr . "\nLoaded."

    return [l:retStr, l:sumStr]
endfunction

function! s:SetInfoWin()
    set filetype=

    "throwaway buffer options
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nowrap
    setlocal nonumber
    setlocal nobuflisted
    setlocal nospell

    " clear fold settings
    setlocal foldcolumn=0
    setlocal foldmethod=manual
    setlocal nofoldenable

    " clear insert mode abbreviations
    iabclear <buffer>

    " local mappings.
    nnoremap <buffer> q :close<CR>

    " highlighting.
    syntax keyword Keyword plugin autoload colors indent ftplugin
    syntax match Title /^\[\d\{3}\] -- \zs\w\+\ze/
endfunction

function! mudox#scripts_man#LoadingStatus()
  let [l:detail, l:summary] = s:SPrintScriptLoadingStatus()

  " get unique buffer name
  if !exists('s:LoadingStatusBufNum')
    let s:LoadingStatusBufNum = 0
  endif

  let s:LoadingStatusBufNum = s:LoadingStatusBufNum + 1

  try
    call mudox#query_open_file#New('Mudox_SLS_' . s:LoadingStatusBufNum)
  catch /^mudox#query_open_file: Canceled$/
    echohl WarningMsg
    echo '* mudox#scripts_man#LoadingStatus: Canceled *'
    echohl None
    return
  endtry

  call s:SetInfoWin()
  call append(0, split(l:detail, "\n"))
  call append(line('$'), split(l:summary, "\n"))
endfunction
