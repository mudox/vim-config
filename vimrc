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

" [zoomwintab]"                                      {{{2
" <M-O/o> to invoke :ZoomWinTabToggle
nnoremap ï :ZoomWinTabToggle<CR>
nnoremap Ï :ZoomWinTabToggle<CR>
" }}}2

" [ft-sql]"                                          {{{2
let g:ftplugin_sql_omni_key_right = '<C-l>'
let g:ftplugin_sql_omni_key_left  = '<C-h>'
"}}}2

" [matchparen]"                                      {{{2
let loaded_matchparen = 1
" }}}2

" [cottidie]"                                        {{{2
command! Tips CottidieTip
" }}}2

" [goldenview]"                                      {{{2
let g:goldenview__enable_default_mapping = 0
" }}}2

" [color: solarized]"                                {{{2
let g:solarized_termcolors = 256
let g:solarized_contrast   = "high"
let g:solarized_bold       = 0
" let g:solarized_underline
" let g:solarized_italic
" }}}2

" [gitgutter]"                                       {{{2
nnoremap \gg :<C-U>GitGutterToggle<CR>
nnoremap <leader>ggn :GitGutterNextHunk<CR>
nnoremap <leader>ggp :GitGutterPrevHunk<CR>
let g:gitgutter_enabled = 0
" }}}2

" [color: kolor]"                                    {{{2
let g:kolor_italic=1                    " Enable italic. Default: 1
let g:kolor_bold=1                      " Enable bold. Default: 1
let g:kolor_underlined=1                " Enable underline for 'Underlined'. Default: 0
let g:kolor_alternative_matchparen=1    " Gray 'MatchParen' color. Default: 0
" }}}2

" [mudox]"                                           {{{2

" let g:mdx_vim_alpha_step = 15
if has('win32') || has('win64')
    nnoremap <silent> <leader>`   :<C-U>call mudox#max_restore_win#Main()<CR>

    " Alt + < / > to decrease or increase transparency of vim win.
    " nnoremap <silent> ® :<C-U>call trans_win#AlphaStep(g:mdx_vim_alpha_step)<CR>
    " nnoremap <silent> ¬ :<C-U>call trans_win#AlphaStep(-g:mdx_vim_alpha_step)<CR>
endif

" }}}2

" [rainbowparentheses] "                             {{{2
nnoremap \rb :<C-U>RainbowParenthesesToggleAll<CR>
"}}}2

" [singlecompile]"                                   {{{2
nnoremap <F5> :<C-U>SCCompileRun<CR>
" if has('win32') || has('win64')
" call SingleCompile#SetCompilerTemplate('python', 'python',
" \'New python3 executable for python3.3.2',
" \'E:\PYF\SDK\Python3\python.exe', '', '')
" call SingleCompile#ChooseCompiler('python', 'python')
" elseif has('unix')
" call SingleCompile#ChooseCompiler('python', 'python3')
" elseif has('mac') || has('macunix')
" call SingleCompile#ChooseCompiler('python', 'python3')
" else
" echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
" endif
"}}}2

" [python-mode]"                                     {{{2
let g:pymode_run                      = 0
let g:pymode_lint                     = 0
let g:pymode_lint_onfly               = 0
let g:pymode_lint_write               = 0
let g:pymode_syntax_print_as_function = 1
let g:pymode_doc_key                  = '<leader>k'
"}}}2

" [taglist]                                          {{{2
let Tlist_Show_One_File             = 1
let Tlist_Exit_OnlyWindow           = 1
if ! has("gui_running")
    let Tlist_Inc_Winwidth          = 0
endif
"}}}2

" [jedi]                                             {{{2
let g:jedi#pydoc                    = "<leader>k"
let g:jedi#popup_select_first       = 0
let g:jedi#auto_vim_configuration   = 0
let g:jedi#show_function_definition = 0
"}}}2

" [mark]                                             {{{2
let g:mwAutoSaveMarks = 0
let g:mwIgnoreCase = 0
" let g:mwHistAdd = '/@'
"}}}2

" [unite]                                            {{{2
nnoremap \mru :Unite -start-insert file_mru<CR>
nnoremap \bm  :Unite -vertical bookmark<CR>
nnoremap \mru :Unite -start-insert file_mru<CR>
nnoremap \ub  :Unite -vertical bookmark<CR>
" let g:unite_enable_start_inser = 1
" let g:unite_split_rule = 'topleft'
" let g:unite_enable_split_vertically
"}}}2

"}}}1

" VIMRC SCRIPTS SETTING {{{1
nnoremap \z   :<C-U>call mudox#z_menu#Main()<CR>
nnoremap \sm  :<C-U>call mudox#scripts_man#LoadingStatus()<CR>
" }}}1

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
set noshowmode   " powerline does better
set showcmd
set noruler      " powerline does better
set shortmess+=I " no intro text when start with an empty buffer.
set nocursorline
set laststatus=0 " never show statusline.
set cmdheight=1

" Brace match
set showmatch
set matchtime=1

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
