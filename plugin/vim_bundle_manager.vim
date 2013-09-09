if exists("vim_bundle_manager")
    finish
endif
let g:vim_bundle_manager = 1

command -nargs=1 -complete=custom,<SID>BundlesAvail EditBundle :call mudox#cfg_bundle#Main(<q-args>)

function <SID>BundlesAvail(arglead, cmdline, cursorpos)
    let l:bundles = glob(g:rc_root . '/vimrc.d/neobundles.d/*', 1, 1)
    call map(l:bundles, 'fnamemodify(v:val, ":t:r")')
    return join(l:bundles, "\n")
endfunction
