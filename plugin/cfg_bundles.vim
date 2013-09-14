if exists("vim_bundle_manager")
    finish
endif
let g:vim_bundle_manager = 1

command -nargs=1 -complete=custom,<SID>BundlesAvail EditBundle call mudox#cfg_bundle#EditBundle(<q-args>)

function <SID>BundlesAvail(arglead, cmdline, cursorpos)
    let l:bundles = glob(g:mudox_bundles_dir . '/*', 1, 1)
    call map(l:bundles, 'fnamemodify(v:val, ":t:r")')
    return join(l:bundles, "\n")
endfunction

command -nargs=* -complete=custom,<SID>ConfigAvail EditConfig call mudox#cfg_bundle#EditConfig(<q-args>)

function <SID>ConfigAvail(arglead, cmdline, cursorpos)
    let l:configs = glob(g:mudox_configs_dir . '/*', 1, 1)
    call map(l:configs, 'fnamemodify(v:val, ":t:r")')
    return join(l:configs, "\n")
endfunction
