function! s:UppercaseKeywords()
    " sql keywords list sorted.
    let l:keyword_list = [
                \ 'create' ,
                \ 'from'   ,
                \ 'insert' ,
                \ 'integer',
                \ 'into'   ,
                \ 'key'    ,
                \ 'not'    ,
                \ 'null'   ,
                \ 'primary',
                \ 'select' ,
                \ 'table'  ,
                \ 'unique' ,
                \ 'values' ,
                \ 'where'
                \ ]

    let l:pattern = l:keyword_list[0]
    for kw in l:keyword_list[1:]
        let l:pattern = l:pattern . '\|' . kw
    endfor
    let l:pattern = '\C\<\(' . l:pattern . '\)\>'

    execute ':%s/' . l:pattern . '/\U&\E/gce'
endfunction

autocmd BufWritePre *.sql call s:UppercaseKeywords()
