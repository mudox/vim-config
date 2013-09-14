" vimrc NOT .vimrc for [G]Vim on Linux / Window   {{{1
"
" NOTE:
" ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- -------
" ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- -------
"
" TODO:
" 1. the use of variables g:vim_config_root is not conventional, and error-prone.
" 2. regrouping the vim options setttings in 'SETTINGS' section.
" 3. fix the issues:
"   * cursor hopping between current insertting position and the line end.
"}}}1

" get the full path of .vim or vimfiles.
let g:vim_config_root = substitute(expand('<sfile>:p:h'), ' ', '\\ ', 'g') " deprecated
let g:rc_root = expand('<sfile>:p:h') " use this to replace the one above.

" NEOBUNDLE                                       {{{1
set nocompatible                " Recommend

if has('vim_starting')
    exe 'set runtimepath+=' . escape(g:rc_root, '\ ') . '/neobundle/neobundle'
endif

call neobundle#rc(g:vim_config_root . '/neobundle')

" Let neobundle manage neobundle
NeoBundleFetch 'Shougo/neobundle.vim' , { 'name' : 'neobundle' }

execute 'NeoBundleLocal ' . escape(g:rc_root, '\ ') . '/bundle'

" Register bundles from under vimrc.d/bundles.d
call mudox#cfg_bundle#RegisterBundles()

filetype plugin indent on       " Required!

" Installation check.
NeoBundleCheck

if !has('vim_starting')
    " Call on_source hook when reloading .vimrc.
    call neobundle#call_hook('on_source')
endif

function NeoUpdateLogs()
    NeoBundleUpdate
    NeoBundleUpdatesLog
endfunction

nnoremap \neo :call NeoUpdateLogs()<CR>
"}}}1

" MAPPINGS                                        {{{1

" Toggle syntax feature.
nnoremap \x :execute 'setlocal syntax=' . ((&syntax == 'OFF') ? 'ON' : 'OFF')<CR>

" Default leader key for <leader> mappings
let g:mapleader = ','

" <C-H/J/K/L> to jump among windows                  {{{2
nnoremap <C-H>	   <C-W>h
nnoremap <C-J>	   <C-W>j
nnoremap <C-K>	   <C-W>k
nnoremap <C-L>	   <C-W>l
"}}}2

" <M-Up/Down/Left/Right> to resize windows           {{{2
nnoremap <M-Up> 	5<C-W>+
nnoremap <M-Down> 	5<C-W>-
nnoremap <M-Left> 	5<C-W><
nnoremap <M-Right> 	5<C-W>>
"}}}2

" <A-H/L> to switch among tabs                       {{{2
nnoremap <silent> ì gt
nnoremap <silent> è gT
"}}}2

" In case you leave CapLock key pressed inadvertently, which will mess you up.
noremap <silent> J @='8j'<CR>
noremap <silent> K @='8k'<CR>
noremap L 
noremap H 
"}}}2

" :noh is frequently used, but typing it is a chore.
nnoremap z/ :noh<CR>
nnoremap z? :set hlsearch!<CR>


" Toggle tab line
nnoremap \t :exe "set showtabline=" . (&showtabline+1)%2<CR>

" key q is too easy to touch, but is needed infrequently
nnoremap q <Nop>
nnoremap _q q

" key Q is too easy to touch, but is needed infrequently
nnoremap Q <Nop>
nnoremap <C-Q> Q

noremap zi zizz

" Move in insert mode
inoremap <C-H> <Left>
inoremap <C-L> <Right>

nnoremap <leader>cd :<C-U>lcd %:p:h<CR>

" like UltisniptEdit command, edit main ftplugin config file
" for current file type.
function! EditFileTypeSettings( filetype )
    let l:ft = ( a:filetype == '' ) ? &filetype : a:filetype
    if l:ft != ''
        let l:setting_file = g:vim_config_root . '/ftplugin/' . l:ft . '.vim'
        exe mudox#query_open_file#Main() . ' ' . l:setting_file
    else
        echohl ErrorMsg
        echo "* No filetype *"
        echohl None
    endif
endfunction
command  -nargs=? Eft call EditFileTypeSettings(<q-args>)

" }}}1

" BUNDLE SETTINGS                                 {{{1

call mudox#cfg_bundle#LoadBundleConfigs()

" [ft-sql]"                                          {{{2
let g:ftplugin_sql_omni_key_right = '<C-l>'
let g:ftplugin_sql_omni_key_left  = '<C-h>'
"}}}2

" [matchparen]"                                      {{{2
let loaded_matchparen = 1
" }}}2

" [mark]                                             {{{2
let g:mwAutoSaveMarks = 0
let g:mwIgnoreCase = 0
" let g:mwHistAdd = '/@'
"}}}2

" [dot_vim]                                          {{{2

" let g:mdx_vim_alpha_step = 15
if has('win32') || has('win64')
    nnoremap <silent> <leader>`   :<C-U>call mudox#max_restore_win#Main()<CR>

    " Alt + < / > to decrease or increase transparency of vim win.
    " nnoremap <silent> ® :<C-U>call trans_win#AlphaStep(g:mdx_vim_alpha_step)<CR>
    " nnoremap <silent> ¬ :<C-U>call trans_win#AlphaStep(-g:mdx_vim_alpha_step)<CR>

endif
nnoremap \z   :<C-U>call mudox#z_menu#Main()<CR>
nnoremap \sm  :<C-U>call mudox#scripts_man#LoadingStatus()<CR>
" }}}2
"}}}1

" EVENTS                                          {{{1

"}}}1

" ABBREVIATES                                     {{{1
cabbrev ue UltiSnipsEdit
"}}}1

" SETTINGS                                        {{{1

" Important
set nocompatible

set guioptions=fcaM

syntax on
filetype plugin indent on " 'filetype on' implied

set encoding=utf8
set termencoding=gbk

" color & font
set background=dark
colorscheme desert_mdx

if has('win32') || has('win64')
    set guifont=YaHei_Consolas_Hybrid:h10:cGB2312
    set linespace=0
    autocmd ColorScheme * set linespace=0
elseif has('unix')
    " under infinality style: winxp
    set guifont=Ubuntu\ Mono\ for\ Powerline\ 11.5
    set linespace=0
    autocmd ColorScheme * set linespace=0
elseif has('mac') || has('macunix') " oops!, I have no Mac OS ...
    " set guifont=Ubuntu\ Mono\ for\ Powerline\ 12
    " set linespace=1
else
    echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
endif

" Editor interface
set noruler      " powerline does better
set shortmess+=I " no intro text when start with an empty buffer.
set nocursorline
if index(g:neo_bundles, 'airline') == -1
    set laststatus=0 " never show statusline.
    set cmdheight=1
    set showmode
    set showcmd
else
    set noshowmode
    set noshowcmd
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
"set autochdir
set sessionoptions=buffers,folds,globals,help,localoptions,options,resize,sesdir,slash,tabpages,unix,winpos,winsize
set autowriteall
set viminfo+=!  " save global variables in viminfo files
set winaltkeys=no " turns of the Alt key bindings to the gui menu

" Insert behaviour
set whichwrap=b,s,<,>,[,],h,l
set backspace=indent,eol,start
set completeopt=menu
set dictionary+=/usr/share/dict/words

" Fold behaviour
set foldtext=MyFoldText()
function! MyFoldText()
    let l:firstline = getline(v:foldstart)
    let l:sub = substitute(l:firstline, '\s*"\|"/\*\|\*/\|{\{3}.*', '', 'g')
    let l:prefix = '» '
    let l:foldline = l:prefix . l:sub
    return l:foldline
endfunction

" Command line completion
set history=30
set wildmenu

if has('unix')
    set wildignorecase "
endif


" multiple windows                                   {{{2
"set hidden " don't unload a buffer when no longer shown in a window.
"}}}2

" vim files syntax hightlighting                     {{{2
let g:vimsyn_embed = 0      " disable all embeding syntax.
let g:vimsyn_folding = 'af' " enable autofolding of autogroups & functions.
let g:vimsyn_noerror = 1
"}}}2

"}}}1

" vim: foldmethod=marker fileformat=unix foldmethod=marker
