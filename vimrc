scriptencoding utf-8

" get the full path of .vim/vimfiles path
" in my configuration, vimrc must be put under .vim/vimfiles.
let g:rc_root = expand('<sfile>:p:h')

" BUNDLE LOADING by VIM-PLUG                                                        {{{1

if has('vim_starting')
  exe 'set runtimepath+=' . escape(g:rc_root, '\ ') . '/bundle/align'
  exe 'set runtimepath+=' . escape(g:rc_root, '\ ') . '/plugged/chameleon'
endif

call mudox#chameleon#Init()

silent! call cmdhub#cmds#register('Install plugins by vim-plug', 'PlugInstall')
silent! call cmdhub#cmds#register('Update all plugins by vim-plug', 'PlugUpdate')
silent! call cmdhub#cmds#register('Upgrade vim-plug itself', 'PlugUpgrade')
"}}}1

" BUNDLE SETTINGS                                                                   {{{1

" [ft-sql]                                                                        "    {{{2
let g:ftplugin_sql_omni_key_right = '<C-l>'
let g:ftplugin_sql_omni_key_left  = '<C-h>'
"}}}2

" [matchparen]                                                                    "    {{{2
"let loaded_matchparen = 1
" }}}2

" [dot_vim]                                                                            {{{2
if has('win32') || has('win64')
  nnoremap ,`  :<C-U>call mudox#max_restore_win#Main()<Cr>
endif
" }}}2

"}}}1

" EVENTS                                                                            {{{1
" force vim into recognising all *.md as markdown instead of Modula-2
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" force all files to be of unix format.
function! Mudox_ff_unix()                                                         "    {{{2
  if !&l:buftype == '' || ! &l:modifiable || &l:readonly ||
        \ &l:fileformat == 'unix'
    return
  endif

  while 1
    echohl Special
    echon "\nfileformat=" . &l:fileformat . ', convert?[y] '
    echohl None

    let key = getchar()
    if key == char2nr('y') ||
          \ key == char2nr('Y') ||
          \ key == char2nr(' ') ||
          \ key == 13 " <Cr> key
      setlocal fileformat=unix
      return
    elseif key == char2nr('n') ||
          \ key == char2nr('N') ||
          \ key == 27 " <Esc> key ||
          \ key == 3 " Ctrl-C key
      return
    endif
  endwhile
endfunction "  }}}2

let s:unix_ff_file_types = [
      \ 'c', 'cpp', 'python', 'ruby',
      \ 'sh', 'bash', 'zsh',
      \ 'php', 'perl', 'html', 'css',
      \ 'vim',
      \ ]

augroup Mudox_ff_fix
  autocmd!

  for s:f in s:unix_ff_file_types
    execute 'autocmd FileType ' . s:f . ' call Mudox_ff_unix()'
  endfor
augroup END
"}}}1

" SETTINGS                                                                          {{{1

" Important
set nocompatible

set guioptions=fcaM
set t_Co=256 " 256 color support on some terminals.

syntax on
filetype plugin indent on " 'filetype on' implied


set encoding=utf8
set termencoding=gbk

" color & font
set background=dark
colorscheme desert

if has('win32') || has('win64')                         " windows
  set guifont=YaHei_Consolas_Hybrid:h10:cGB2312
  set linespace=0
  autocmd ColorScheme * set linespace=0
elseif has('mac') || has('macunix')                     " mac os x
  set guifont=Monaco\ for\ Powerline:h11
  set linespace=0
elseif has('unix')                                      " other *nix
  " Awsome WM on ArchLinux without infinality.

  " suit for default theme of awesome on archlinux.
  set guifont=Ubuntu\ Mono\ for\ Powerline\ 11.8
  set linespace=1
  autocmd ColorScheme * set linespace=1

  " suit for zenburn theme of awesome on archlinux.
  "set guifont=Ubuntu\ Mono\ for\ Powerline\ 11.5
  "set linespace=0
  "autocmd ColorScheme * set linespace=0
else
  echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
endif

" Editor interface
set noruler      " powerline does better
set shortmess+=I " no intro text when start with an empty buffer.
set nocursorline
set showtabline=1

set noshowcmd
if index(g:mdx_chameleon.meta_set, 'airline') == -1
  set laststatus=1 " never show statusline.
  set cmdheight=1
  set showmode
else
  set noshowmode
  set laststatus=2
  set cmdheight=2
endif

" Brace match
set noshowmatch

" Tab setting
" using expandtab scheme
set tabstop=8
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set listchars=tab:▸-,eol:¶
set autoindent

" Pattern searching
set nohlsearch
set wrapscan
set incsearch
set ignorecase
set smartcase

" Editor behaviour
set whichwrap=b,s,<,>,[,],h,l
set backspace=indent,eol,start
set autochdir
set sessionoptions=buffers,folds,globals,help,localoptions,options,resize,sesdir,slash,tabpages,unix,winpos,winsize
set autowriteall
set viminfo+=!  " save global variables in viminfo files
set winaltkeys=no " turns of the Alt key bindings to the gui menu

" Insert behaviour
set whichwrap=b,s,<,>,[,],h,l
set backspace=indent,eol,start
set completeopt=menu
set dictionary+=/usr/share/dict/words

" Command line completion
set wildmenu

if has('unix')
  set wildignorecase "
endif

" displaying text
set nolazyredraw

" backup
set nobackup
set noswapfile
set nowritebackup

set hidden "ctrlspace need this setting

"}}}1

" MAPPINGS                                                                          {{{1

" Toggle syntax feature.
nnoremap coX :execute 'setlocal syntax=' . ((&syntax == 'OFF') ? 'ON' : 'OFF')<Cr>

" Default leader key for <leader> mappings
let g:mapleader = ','

" quick save.
nnoremap <BS>W :w<Cr>:e!<Cr>
nnoremap <BS>w :w<Cr>

" j, k to easily move around in wrapped long line.                                     {{{2
nnoremap k gk
nnoremap j gj
nmap gk <Nop>
nmap gj <Nop>
" }}}2

" <C-H/J/K/L> to jump among windows                                                    {{{2
nnoremap <C-H>	   <C-W>h
nnoremap <C-L>	   <C-W>l
nnoremap <C-K>	   <C-W>k
nnoremap <C-J>	   <C-W>j
"}}}2

" <A-H/L> to switch among tabs                                                         {{{2
nnoremap <silent> <M-l> gt
nnoremap <silent> <M-h> gT
nnoremap <silent> <M-L> gt
nnoremap <silent> <M-H> gT
nnoremap <silent> Ó gt
nnoremap <silent> Ò gT
nnoremap <silent> ˙ gt
nnoremap <silent> ¬ gT
"}}}2

" In case you leave CapLock key pressed inadvertently, which will mess you up.
noremap <silent> J @='8gj'<Cr>
noremap <silent> K @='8gk'<Cr>
noremap L 
noremap H 
"}}}2

" <C-X> system shortcuts                                                               {{{2
inoremap <M-j> <C-N>
inoremap <M-J> <C-N>
inoremap <M-k> <C-P>
inoremap <M-K> <C-P>

" <M-O><A-J>
inoremap <M-o><M-j> <C-X><C-O>
inoremap <M-O><M-J> <C-X><C-O>
inoremap <M-o><M-k> <C-X><C-O>
inoremap <M-O><M-K> <C-X><C-O>

" }}}2

" Toggle tab line
nnoremap cotab :let &showtabline = ( &showtabline == 0 ? 2 : 0 )<Cr>

" Dump output of an ex-command into a buffer opened in new tab.                        {{{2
function! g:MdxDumpExCmdOutput(cmd)
  try
    redi @"
    silent execute a:cmd
    redi END
    tabnew
    call append(0, split(@", '\n'))
    delete _
  catch /.*/
    echohl ErrorMsg | echo v:exception | echohl None
  endtry
endfunction

function g:MdxDumpExCmdOutputFromInput()
  let cmd = input('command: ')
  if len(cmd) == 0
    return
  endif

  call MdxDumpExCmdOutput(cmd)
endfunction

nnoremap \cmd :call MdxDumpExCmdOutputFromInput()<Cr>
" }}}2

" key q is too easy to touch, but is needed infrequently
nnoremap q <Nop>
nnoremap _q q

" key Q is too easy to touch, but is needed infrequently
nnoremap Q <Nop>
nnoremap <C-Q> Q

noremap zi zizz

" insert mode                                                                          {{{2
inoremap <C-J> <Down>
inoremap <C-H> <Left>
inoremap <C-L> <Right>
" }}}2

" change cwd to current file path.
nnoremap <leader>cd :<C-U>lcd %:p:h<Cr>:pwd<Cr>

" like UltisniptEdit command, edit main ftplugin config file
" for current file type.

function! <SID>FileTypesAvail(arglead, cmdline, cursorpos)
  " suppress vilint warnings.
  let _ = a:arglead
  let _ = a:cmdline
  let _ = a:cursorpos
  let _ = _

  let filetypes = glob(g:rc_root . '/ftplugin/*.vim', 1, 1)
  call map(filetypes, 'fnamemodify(v:val, ":t:r")')
  return join(filetypes, "\n")
endfunction

function! EditFileTypeSettings( filetype )
  let ft = ( a:filetype == '' ) ? &filetype : a:filetype
  try
    if ft != ''
      let setting_file = g:rc_root . '/ftplugin/' . ft . '.vim'
      call Qpen(setting_file)
    else
      echohl ErrorMsg
      echo "* No filetype *"
      echohl None
    endif
  catch /^mudox#query_open_file: Canceled$/
    echohl WarningMsg | echo '* EditFileTypeSettings: Canceled *' | echohl None
    return
  endtry
endfunction

command  -nargs=? -complete=custom,<SID>FileTypesAvail EditFileType
      \ call EditFileTypeSettings(<q-args>)
nnoremap <BS>f :EditFileType<Space>

" command mode mappings.
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" quickly fix previous spelling error with the first candidate.
nnoremap <s [sz=1<Cr><Cr>''

" }}}1

" ABBREVIATES                                                                       {{{1
"}}}1

call mudox#chameleon#InitBundles()

" vim: foldmethod=marker fileformat=unix foldmethod=marker foldcolumn=2
