" cmdhub: Profiling vim startup

let cmd = printf('MDX_CHAMELEON_MODE=%s %s',
      \ g:mdx_chameleon_mode_name,
      \ has('nvim') ? 'nvim' : 'vim')
let cmd .= ' --cmd "profile start /tmp/vim_startup_profile.log"' .
      \ ' --cmd "profile func *"' .
      \ ' --cmd "profile file *"' .
      \ ' -c "profdel func *"' .
      \ ' -c "profdel file *"' .
      \ ' -c "qa!"'
let ret = systemlist(cmd)
tabnew /tmp/vim_startup_profile.log
