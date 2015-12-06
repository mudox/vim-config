" cmdhub: Profiling vim startup

let cmd = printf('MDX_CHAMELEON_MODE=%s %s',
      \ g:mdx_chameleon_mode_name,
      \ has('nvim') ? 'nvim' : 'vim')
let cmd .= ' --startuptime /tmp/vim_startup_time.log' .
      \ ' --cmd "profile start /tmp/vim_startup_profile.log"' .
      \ ' --cmd "profile func *"' .
      \ ' --cmd "profile file *"' .
      \ ' -c "profdel func *"' .
      \ ' -c "profdel file *"' .
      \ ' -c "qa!"'

echohl WarningMsg
echo 'profiling ...'
echohl None

silent let ret = systemlist(cmd)

silent tabnew! /tmp/vim_startup_profile.log
normal! gG
silent tabnew! /tmp/vim_startup_time.log
normal! gG
