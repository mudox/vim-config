if exists("vim_bundle_manager")
    finish
endif
let g:vim_bundle_manager = 1

command -nargs=1 -complete=custom,<SID>BundlesAvail EditBundle call mudox#cfg_bundle#EditBundle(<q-args>)

function <SID>BundlesAvail(arglead, cmdline, cursorpos)
    return join(mudox#cfg_bundle#BundleListAvail(), "\n")
endfunction

command -nargs=* -complete=custom,<SID>ConfigAvail EditConfig call mudox#cfg_bundle#EditConfig(<q-args>)

function <SID>ConfigAvail(arglead, cmdline, cursorpos)
    return join(mudox#cfg_bundle#ConfigListAvail(), "\n")
endfunction

command -nargs=0 MdxInfo call s:CfgInfo()

function! s:CfgInfo()
    echohl Title | echon printf("%-30s: ", 'Current Configuration Name') | echohl None
    echohl Identifier | echon printf("%s\n", g:mdx_config_name) | echohl None

    echohl Title | echon printf("%-30s: ", 'Sourced Config Files') | echohl None
    echohl Identifier | echon printf("%s\n", join(g:mdx_config_sourced, ' ')) | echohl None

    echohl Title | echo printf("%-30s:\n", "Bundles Enrolled") | echohl None

    let l:max_width = max(map(copy(g:mdx_loaded_bundles), 'len(v:val)')) + 2
    echohl Special
    let l:fields = &columns / l:max_width
    for i in range(len(g:mdx_loaded_bundles))
        execute 'echon printf("%-' . l:max_width . 's", g:mdx_loaded_bundles[i])'
        if (i + 1) % l:fields == 0
            echo ''
        endif
    endfor
    echohl None
endfunction
