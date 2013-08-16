function! s:LoadingStatusDict()
    " get the output of ":scriptnames" in the l:scriptnames_output variable.
    let l:scriptnames_output = ''
    redir => l:scriptnames_output
    silent scriptnames
    redir END

    let l:list_of_lines = split(l:scriptnames_output, '\n')

    " strip prefix numbers.
    for i in range(len(l:list_of_lines))
        let l:list_of_lines[i] = l:list_of_lines[i][5:]
    endfor

    " only interested in 'neobundle/' or 'bundle/' lines
    call filter(l:list_of_lines, 'v:val =~ "neobundle" || v:val =~ "bundle"')
    call sort(l:list_of_lines)

    let l:plugin = ''
    let l:dict_of_scripts = {}

    for l:line in l:list_of_lines
        let l:tmp = matchstr(l:line, '\c\(neobundle\|bundle\)\(\\\|\/\)\zs[^\\/]\+\ze\2')
        if l:plugin != l:tmp
            let l:plugin = l:tmp
            let l:dict_of_scripts[l:plugin] = []
        endif

        let l:file_line = substitute(l:line, '^.\{-}\(neobundle\|bundle\)', '\t', '')
        call add(l:dict_of_scripts[l:plugin], l:file_line)
    endfor

    return l:dict_of_scripts
endfunction

function! s:SPrintScriptLoadingStatus()
    let l:nr_plug = 0
    let l:nr_file = 0
    let l:retStr = ''

    for [l:script, l:files] in items(s:LoadingStatusDict())
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
    echo l:summary

    if !exists('s:LoadingStatusBufNum')
        let s:LoadingStatusBufNum = 0
    endif

    let s:LoadingStatusBufNum = s:LoadingStatusBufNum + 1

    execute mudox#query_open_file#Main() . 'Mudox_SLS_' . s:LoadingStatusBufNum

    call s:SetInfoWin()
    call append(line('$'), split(l:detail, "\n"))
    call append(line('$'), split(l:summary, "\n"))
endfunction
