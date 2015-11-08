" cmdhub: Play with jq

let s:json_file = '/tmp/mdx_input.json'
let s:jq_file = '/tmp/mdx_filter.jq'
let s:pipe_file = '/tmp/mdx_tty_sucker'

exe 'tabnew ' . s:json_file
exe 'botright new ' . s:jq_file
botright vnew
exe 'term zsh -i -c tsuck'
80wincmd |
wincmd w
exe printf('nnoremap <silent> <buffer> <bs>r :silent !echo "jq -f %s %s" > %s<Cr>',
      \ s:jq_file, s:json_file, s:pipe_file)
wincmd w
exe printf('nnoremap <silent> <buffer> <bs>r :silent !echo "jq -f %s %s" > %s<Cr>',
      \ s:jq_file, s:json_file, s:pipe_file)
call delete('/tmp/mdx_tty_sucker')

unlet s:json_file
unlet s:jq_file
unlet s:pipe_file
