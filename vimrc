" vimrc NOT .vimrc for [G]Vim on Linux / Window    {{{1
"
" NOTE:
" ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- -------
" This vimrc has several preconditions:
" * This file 'vimrc' NOT '.vimrc' must reside in the root directory of .vim or
"   vimfiles directory, while the formally '.vimrc' file, containing a single line
"   to source this file, resides just outisde .vim or vimfiles direcotry. By doing
"   this, we can conveniently use git to manage the whole vim configuration stuff.
" * Assumes you haved defined a system or user environment variable: MDX_DROPBOX
"   which holds the absolute path to dropbox root path. (deprecated)
" ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- -------
" This vimrc follows several predefined laws:
" * Mapping scheme:
"   1. use '\' to map relatively infrequently used functions.
"   2. usr g:mapleader & b:localleader to map relatively frequently used functions.
" * Use g:vim_config_root to gain the full path of .vim or vimfies directory.
" ------- ------- ------- ------- ------- ------- ------- ------- ------- ------- -------
"}}}1

" get the full path of .vim or vimfiles. 
let g:vim_config_root = substitute(expand('<sfile>:p:h'), ' ', '\\ ', 'g')

" NEOBUNDLE                                        {{{1
set nocompatible                " Recommend

if has('vim_starting')
    exe 'set runtimepath+=' . g:vim_config_root . '/neobundle/neobundle'
endif

call neobundle#rc(g:vim_config_root . '/neobundle')

" Let neobundle manage neobundle
NeoBundleFetch 'Shougo/neobundle.vim' , { 'name' : 'neobundle' }

" Use neobundle standard recipes.
NeoBundle 'Shougo/neobundle-vim-scripts'

" My Bundles here:                                 {{{2

" [Vimproc]
NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \    'unix'    : 'make -f make_unix.mak'
            \    }
            \ }

" [Vimfiler]
NeoBundle 'Shougo/vimfiler'

" [Vimshell]
NeoBundleLazy 'Shougo/vimshell',{
            \     'autoload' : {
            \       'commands' : [
            \           { 
            \           'name'     : 'VimShell',
            \           'complete' : 'customlist,vimshell#complete'
            \           },
            \           'VimShellExecute', 
            \           'VimShellInteractive',
            \           'VimShellTerminal',
            \           'VimShellPop'
            \       ],
            \       'mappings' : [ '<Plug>(vimshell_switch)' ]
            \     }
            \ }

" [Powerline]
NeoBundle 'Lokaltog/powerline', {
            \ 'name' : 'powerline',
            \ 'rtp'  : 'powerline/bindings/vim'
            \}
" [Unite]
NeoBundle 'Shougo/unite.vim'
" [delimitMate]
NeoBundle 'Raimondi/delimitMate'               , { 'name' : 'delimitmate' }
" [Easytags]
NeoBundle 'xolox/vim-easytags'                 , { 'name' : 'easytags' }
" [Vim-textobj-syntax]
NeoBundle 'kana/vim-textobj-syntax'            , { 'name' : 'textobj_syntax' }
" [Vim-textobj-function]
NeoBundle 'kana/vim-textobj-function'          , { 'name' : 'textobj_function' }
" [Vim-textobj-entire]
NeoBundle 'kana/vim-textobj-entire'            , { 'name' : 'textobj_entire' }
" [Vim-textobj-indent]
NeoBundle 'kana/vim-textobj-indent'            , { 'name' : 'textobj_indent' }
" [textobj-comment]
NeoBundle 'glts/vim-textobj-comment'           , { 'name' : 'textobj_comment' }
" [Vim-textobj-line]
NeoBundle 'kana/vim-textobj-line'              , { 'name' : 'textobj_line' }
" [Vim-textobj-user]
NeoBundle 'kana/vim-textobj-user'              , { 'name' : 'textobj_user' }
" [Textobj-word-column]
NeoBundle 'coderifous/textobj-word-column.vim' , { 'name' : 'textobj_word_column'}
" [vim-multiple-cursors]
NeoBundle 'terryma/vim-multiple-cursors'       , { 'name' : 'multiple_cursors' }
" [Nrrwrgn]
NeoBundle 'chrisbra/NrrwRgn'                   , { 'name' : 'nrrwrgn' }
" [Repeat]
NeoBundle 'tpope/vim-repeat'                   , { 'name' : 'repeat' }
" [Unimpaired]
NeoBundle 'tpope/vim-unimpaired'               , { 'name' : 'unimpaired' }
" [Abolish]
NeoBundle 'tpope/vim-abolish'                  , { 'name' : 'abolish' }
" [singlecompile]
NeoBundle 'xuhdev/SingleCompile'               , { 'name' : 'singlecompile' }
" [yankring]
NeoBundle 'vim-scripts/YankRing.vim'           , { 'name' : 'yankring' }
" [flake8]
NeoBundle 'nvie/vim-flake8'                    , { 'name' : 'flake8' }
" [FSwitch]
NeoBundle 'vim-scripts/FSwitch'                , { 'name' : 'fswitch' }
" [EasyMotion]
NeoBundle 'Lokaltog/vim-easymotion'            , { 'name' : 'easymotion' }
" [Vim-Indent-Guides]
NeoBundle 'mutewinter/vim-indent-guides'       , { 'name' : 'indent_guides' }
" [SrcExpl]
NeoBundle 'wesleyche/SrcExpl'                  , { 'name' : 'srcexpl' }
" [BufExplorer]
NeoBundle 'vim-scripts/bufexplorer.zip'        , { 'name' : 'bufexplorer' }
" [Fugitive]
NeoBundle 'tpope/vim-fugitive'                 , { 'name' : 'fugitive' }
" [Surround]
NeoBundle 'tpope/vim-surround'                 , { 'name' : 'surround' }
" [Align]
NeoBundle 'vim-scripts/Align'                  , { 'name' : 'align' }
" [vim-multiple-cursors]
NeoBundle 'terryma/vim-multiple-cursors'       , { 'name' : 'multiple_cursors' }
" [vim-expand-region]
NeoBundle 'terryma/vim-expand-region'          , { 'name' : 'expand_region' }
" [YouCompleteMe]
if has('unix')
    NeoBundle 'Valloric/YouCompleteMe'         , { 'name' : 'youcompleteme' }
endif
" [zencoding-vim]
NeoBundle 'mattn/zencoding-vim'                , { 'name' : 'zencoding' }
" [indentline]
NeoBundle 'Yggdroot/indentLine'                , { 'name' : 'indentline' }
" [dbext]
NeoBundle 'vim-scripts/dbext.vim'              , { 'name' : 'dbext' }
" [join]
NeoBundle 'sk1418/Join'                        , { 'name' : 'join' }
" [gitgutter]
NeoBundle 'airblade/vim-gitgutter'             , { 'name' : 'gitgutter' }
" [colorv]
NeoBundle 'Rykka/colorv.vim'                   , { 'name' : 'colorv' }
" [origami]
NeoBundle 'kshenoy/vim-origami'                , { 'name' : 'origami' }
" [TagList]
NeoBundle 'vim-scripts/taglist.vim'            , { 'name' : 'taglist' }
" [colorv] related
NeoBundle 'mattn/webapi-vim'                   , { 'name' : 'webapi' }
NeoBundle 'Rykka/galaxy.vim'                   , { 'name' : 'galaxy' }
" [Zoomwintab]
NeoBundle 'troydm/zoomwintab.vim'              , { 'name' : 'zoomwintab' }
" [Mudox-vim-scripts]
NeoBundle 'Mudox/mudox-vim-scripts'            , { 'name' : 'mudox' }
" [rainbow_parentheses]
NeoBundle 'kien/rainbow_parentheses.vim'       , { 'name' : 'rainbow_parentheses' }
" [mudox_ultisnips]
NeoBundle 'Mudox/ultisnips_snippets'           , { 'name' : 'mudox_ultisnips' }
" [jedi-vim]
NeoBundle 'davidhalter/jedi-vim'               , { 'name' : 'jedi_vim' }
" [python-mode]
NeoBundle 'klen/python-mode'                   , { 'name' : 'python_mode' }
" [vim-misc]
NeoBundle 'xolox/vim-misc'                     , { 'name' : 'vim_misc' }
" [pyton-syntax]
NeoBundle 'hdima/python-syntax'                , { 'name' : 'python_syntax' }
" [abolish]
NeoBundle 'tpope/vim-abolish'                  , { 'name' : 'vim_abolish' }
" [vim-markdown]
NeoBundle 'plasticboy/vim-markdown'            , { 'name' : 'vim_markdown' }
" [python-vim-instant-markdown]
NeoBundle 'isnowfy/python-vim-instant-markdown', { 'name' : 'python_vim_instant_markdown' }
" [vim-cpp_enhanced_highlight]
NeoBundle 'octol/vim-cpp-enhanced-highlight'   , { 'name' : 'cpp_enhanced_highlight' }
" [GoldenView.vim]
NeoBundle 'zhaocai/GoldenView.Vim'             , { 'name' : 'goldenview' }
" [DrawIt]
NeoBundle 'vim-scripts/DrawIt'                 , { 'name' : 'drawit' }
" [vcscommand]
NeoBundle 'http://repo.or.cz/r/vcscommand.git'
" [vimwiki]
NeoBundle 'vim-scripts/vimwiki'
" [TagBar]
NeoBundle 'majutsushi/tagbar'
" [Syntastic]
NeoBundle 'scrooloose/syntastic'
" [NerdCommenter]
NeoBundle 'scrooloose/nerdcommenter'
" [NerdTree]
NeoBundle 'scrooloose/nerdtree'
" [UltiSnips]
NeoBundle 'SirVer/ultisnips'

" ======================== DEPRECATED PLUGINS ========================

" [MatchTagAlways]
" NeoBundle 'Valloric/MatchTagAlways'            , { 'name' : 'matchtagsalways' }

" [vim-signature]
" NeoBundleLazy 'kshenoy/vim-signature', { 
            " \   'name'     : 'signature',
            " \   'autoload' : { 'commands' : 'SignatureToggle' }

" [clang_complete]
" NeoBundleLazy 'Rip-Rip/clang_complete', {
            " \   'autoload' : {
            " \       'filetypes' : ['c', 'cpp'],
            " \   },
            " \ }

"}}}2

" My Colorscheme Bundles here:                     {{{2

function! Colo_Opt_Dict( name, vim_name )
    " let s:bundle_path = expand('$HOME/.vim/colos_neobundle')
    " let s:colors_path = expand('$HOME/.vim/colors') 
    let s:bundle_path = g:vim_config_root . '/colos_neobundle'
    let s:colors_path = g:vim_config_root . '/colors'

    let s:colo_options       = {}
    let s:colo_options.name  = a:name
    let s:colo_options.base  = s:bundle_path
    let s:colo_options.build = { 
                \   'unix' : 'cp ' 
                \       . a:vim_name . ' ' . s:colors_path,
                \   'windows' : 'copy /Y ' 
                \       . a:vim_name . ' ' . s:colors_path 
                \ }

    return s:colo_options
endfunction

NeoBundleFetch 'w0ng/vim-hybrid', 
            \ Colo_Opt_Dict( 'hybrid', 'colors/hybrid.vim' )
NeoBundleFetch 'tomasr/molokai', 
            \ Colo_Opt_Dict( 'molokai', 'colors/molokai.vim' ) 
NeoBundleFetch 'nanotech/jellybeans.vim', 
            \ Colo_Opt_Dict( 'jellybeans', 'colors/jellybeans.vim' ) 
NeoBundleFetch 'sjl/badwolf', 
            \ Colo_Opt_Dict( 'badwolf', 'colors/badwolf.vim' ) 
NeoBundleFetch 'hukl/Smyck-Color-Scheme', 
            \ Colo_Opt_Dict( 'smyck', 'smyck.vim' ) 
NeoBundleFetch 'jelera/vim-gummybears-colorscheme', 
            \ Colo_Opt_Dict( 'gummybears', 'colors/gummybears.vim' ) 
NeoBundleFetch 'YorickPeterse/Autumn.vim', 
            \ Colo_Opt_Dict( 'autumn', 'colors/autumn.vim' ) 
NeoBundleFetch 'mbbill/desertEx', 
            \ Colo_Opt_Dict( 'desertEx', 'colors/desertEx.vim' ) 
NeoBundleFetch 'altercation/vim-colors-solarized', 
            \ Colo_Opt_Dict( 'solarized', 'colors/solarized.vim' ) 
NeoBundleFetch 'zeis/vim-kolor', 
            \ Colo_Opt_Dict( 'kolor', 'colors/kolor.vim' ) 
NeoBundleFetch 'larssmit/vim-getafe', 
            \ Colo_Opt_Dict( 'getafe', 'colors/getafe.vim' ) 
NeoBundleFetch 'noahfrederick/Hemisu', 
            \ Colo_Opt_Dict( 'hemisu', 'colors/hemisu.vim' ) 
NeoBundleFetch 'morhetz/gruvbox', 
            \ Colo_Opt_Dict( 'gruvbox', 'colors/gruvbox.vim' ) 
NeoBundleFetch 'junegunn/seoul256.vim', 
            \ Colo_Opt_Dict( 'seoul', 'colors/seoul256.vim' ) 
NeoBundleFetch 'jnurmine/Zenburn', 
            \ Colo_Opt_Dict( 'zenburn', 'colors/zenburn.vim' ) 
NeoBundleFetch 'gregsexton/Atom', 
            \ Colo_Opt_Dict( 'atom', 'colors/atom.vim' ) 
NeoBundleFetch 'jonathanfilip/vim-lucius', 
            \ Colo_Opt_Dict( 'lucius', 'colors/lucius.vim' ) 
NeoBundleFetch 'Pychimp/vim-luna', 
            \ Colo_Opt_Dict( 'luna', 'colors/luna.vim' ) 
"}}}2

exe 'NeoBundleLocal ' . g:vim_config_root . '/bundle'

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

" FROM SAMPLE FILE                                 {{{1

" An example for a gvimrc file.
" The commands in this are executed when the GUI is started.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2001 Sep 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.gvimrc
"	      for Amiga:  s:.gvimrc
"  for MS-DOS and Win32:  $VIM\_gvimrc
"	    for OpenVMS:  sys$login:.gvimrc

" Make external commands work through a pipe instead of a pseudo-tty
"set noguipty

" set the X11 font to use
" set guifont=-misc-fixed-medium-r-normal--14-130-75-75-c-70-iso8859-1

set ch=2		" Make command line two lines high

set mousehide		" Hide the mouse when typing text

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Only do this for Vim version 5.0 and later.
if version >= 500

  " I like highlighting strings inside C comments
  let c_comment_strings=1

  " Switch on syntax highlighting if it wasn't on yet.
  if !exists("syntax_on")
    syntax on
  endif

  " Switch on search pattern highlighting.
  set hlsearch

  " For Win32 version, have "K" lookup the keyword in a help file
  "if has("win32")
  "  let winhelpfile='windows.hlp'
  "  map K :execute "!start winhlp32 -k <cword> " . winhelpfile <CR>
  "endif

  " Set nice colors
  " background for normal text is light grey
  " Text below the last line is darker grey
  " Cursor is green, Cyan when ":lmap" mappings are active
  " Constants are not underlined but have a slightly lighter background
  highlight Normal guibg=grey90
  highlight Cursor guibg=Green guifg=NONE
  highlight lCursor guibg=Cyan guifg=NONE
  highlight NonText guibg=grey80
  highlight Constant gui=NONE guibg=grey95
  highlight Special gui=NONE guibg=grey95

endif
" }}}1

" MAPPINGS                                         {{{1

" Default leader key for <leader> mappings
let g:mapleader = ','

map <Up> gk
map <Down> gj

" Ctrl + h / j / k / l to jump among windows       {{{2
nnoremap <C-H>	   <C-W>h
nnoremap <C-J>	   <C-W>j
nnoremap <C-K>	   <C-W>k
nnoremap <C-L>	   <C-W>l
"}}}2

" Ctrl + Shift + Arrow Keys to resize windows      {{{2
nnoremap <C-S-Up> 		5<C-W>+
nnoremap <C-S-Down> 	5<C-W>-
nnoremap <C-S-Left> 	5<C-W>< 
nnoremap <C-S-Right> 	5<C-W>>
"}}}2

" Ctrl + Alt + Left / Right Arrow to move tabs     {{{2
nnoremap <silent> <M-C-Left> :if tabpagenr() == 1\|exe "tabm ".tabpagenr("$")\|el\|exe "tabm ".(tabpagenr()-2)\|en<CR>
nnoremap <silent> <M-C-Right> :if tabpagenr() == tabpagenr("$")\|tabm 0\|el\|exe "tabm ".tabpagenr()\|en<CR>
"}}}2

" Atl + Left / Right Arrow to switch among tabs    {{{2
nnoremap <silent> <M-Left> gT
nnoremap <silent> <M-Right> gt
"}}}2

" Ctrl + S / F to switch among tabs                {{{2
nnoremap <silent> <C-S> gT
nnoremap <silent> <C-F> gt
"}}}2

" Ctr + Left / Right Arrow to switch current buffer{{{2
nnoremap <silent> <C-Left> :bnext<CR>
nnoremap <silent> <C-Right> :bNext<CR>
"}}}2

" In case you leave CapLock key pressed inadvertently, which will mess you up.
noremap <silent> J @='8j'<CR>
noremap <silent> K @='8k'<CR>
noremap L 
noremap H 

" :noh is frequently used, but typing it is a chore
nnoremap z/ :noh<CR>
nnoremap z? :set hlsearch!<CR>


" Toggle tab line
nnoremap \t :exe "set showtabline=" . (&showtabline+1)%2<CR>

" key q is too easy to touch, but is needed infrequently
nnoremap q <Nop>
nnoremap _q q

noremap zi zizz
" Move in insert mode 
inoremap <C-H> <Left>
inoremap <C-L> <Right>

nnoremap <leader>cd :<C-U>lcd %:p:h<CR>

function! EditFileTypeSettings( filetype )
    let l:ft = ( a:filetype == '' ) ? &filetype : a:filetype
    if l:ft != ''
        let l:setting_file = g:vim_config_root . '/ftplugin/' . l:ft . '.vim'
        exe query_open_file#Main() . l:setting_file
    else
        echohl ErrorMsg
        echo "* No filetype *"
        echohl None
    endif
endfunction
command  -nargs=? Eft call EditFileTypeSettings(<q-args>)

" }}}1

" PULGIN SETTINGS                                  {{{1

" [vimproc]"                                    {{{2
if has('win32') || has('win64')
    let g:stdoutencoding = 'cp936'
endif
" }}}2

" [goldenview]"                                    {{{2
let g:goldenview__enable_default_mapping = 0
nmap <silent> <C-O>s <Plug>GoldenViewSplit
" }}}2

" [surround]"                                      {{{2
xmap ' S'
" xmap " S"
xmap ( S(
xmap ) S)
xmap { S{
xmap } S}
" xmap [ S[
" xmap ] S]
" }}}2

" [solarized]"                                     {{{2
let g:solarized_termcolors = 256
let g:solarized_contrast   = "high"
let g:solarized_bold       = 0
" let g:solarized_underline
" let g:solarized_italic
" }}}2

" [gitgutter]"                                     {{{2
nnoremap \gg :<C-U>GitGutterToggle<CR> 
let g:gitgutter_enabled = 0
" }}}2

" [syntastic]"                                     {{{2
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 1

if has('win32') || has('win64')
        let syntastic_error_symbol = 'x'
        let syntastic_warning_symbol = '!'
elseif has('unix')
        let syntastic_error_symbol = '✗'
        let syntastic_warning_symbol = '⚠'
elseif has('mac') || has('macunix')
        let syntastic_error_symbol = '✗'
        let syntastic_warning_symbol = '⚠'
else
    echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
endif

" let syntastic_style_error_symbol
" let syntastic_style_warning_symbol
let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_jump=1
" let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=5
" let g:syntastic_ignore_files=['^/usr/include/', '\c\.h$']
let g:syntastic_mode_map = { 
            \ 'mode': 'passive',
            \ 'active_filetypes': ['ruby', 'php'],
            \ 'passive_filetypes': ['puppet'] 
            \ }
let g:syntastic_stl_format = '%E{%e ✗}%B{, }%W{%w ⚠}'

" checker options
let g:syntastic_c_checkers = ['<ycm>']
let g:syntastic_cpp_checkers = ['<ycm>']
" }}}2

" [vimwiki]"                                       {{{2
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_hl_headers    = 1
let g:vimwiki_global_ext    = 0
let g:vimwiki_listsyms      = ' .oOX'

let g:vimwiki_list = []

let s:wiki_root = expand('$MDX_DROPBOX/WIKI.DROP')
let s:wiki_nested_syntaxes = {
            \'python' : 'python',
            \'c++'    : 'cpp',
            \'sql'    : 'sql'
            \}

" Below is my vimviki sections ...

" wiki 'misc'
let s:wiki               = {}
let s:wiki.path          = s:wiki_root . '/misc/'
let s:wiki.path_html     = s:wiki_root . '/misc/html/'
let s:wiki.nested_syntaxes = s:wiki_nested_syntaxes
call add(g:vimwiki_list, s:wiki)

" wiki 'IT'
let s:wiki               = {}
let s:wiki.path          = s:wiki_root . '/IT/'
let s:wiki.path_html     = s:wiki_root . '/IT/html/'
let s:wiki.auto_export   = 1
let s:wiki.nested_syntaxes = s:wiki_nested_syntaxes
call add(g:vimwiki_list, s:wiki)

" wiki 'English'
let s:wiki               = {}
let s:wiki.path          = s:wiki_root . '/English/'
let s:wiki.path_html     = s:wiki_root . '/English/html/'
let s:wiki.auto_export   = 1
call add(g:vimwiki_list, s:wiki)

" wiki 'Math'
let s:wiki               = {}
let s:wiki.path          = s:wiki_root . '/Math/'
let s:wiki.path_html     = s:wiki_root . '/Math/html/'
let s:wiki.auto_export   = 1
call add(g:vimwiki_list, s:wiki)
" }}}2

" [color: kolor]"                                  {{{2
let g:kolor_italic=1                    " Enable italic. Default: 1
let g:kolor_bold=1                      " Enable bold. Default: 1
let g:kolor_underlined=1                " Enable underline for 'Underlined'. Default: 0
let g:kolor_alternative_matchparen=1    " Gray 'MatchParen' color. Default: 0
" }}}2

" [textobj-comment]"                               {{{2
let g:textobj_comment_no_default_key_mappings = 1
xmap ax <Plug>(textobj-comment-a)
omap ax <Plug>(textobj-comment-a)
xmap ix <Plug>(textobj-comment-i)
omap ix <Plug>(textobj-comment-i)
xmap aX <Plug>(textobj-comment-big-a)
omap aX <Plug>(textobj-comment-big-a)
" }}}2

" [indentline]"                                    {{{2
nnoremap <leader>il :<C-U>IndentLinesToggle<CR>

" let g:indentLine_char = '.'
" let g:indentLine_color_term = 239
" let g:indentLine_color_gui = '#389900'
" }}}2

" [mudoxvimscripts]"                               {{{2
" let g:mdx_colos_white_list = [
            " \   'badwolf'
            " \ ] " just for testing ...
let g:mdx_colos_black_list = [
            \   'galaxy'
            \ ]

" let g:mdx_colos_256_white_list = [
            " \   'badwolf', 
            " \   'blackboard',
            " \   'desert_mdx',  
            " \   'diablo3_mdx', 
            " \   'hybrid',      
            " \   'jellybeans',  
            " \   'lucius',      
            " \   'molokai',     
            " \   'valloric',    
            " \   'zenburn'      
            " \ ]                
let g:mdx_colos_256_black_list = [
            \   'galaxy',      
            \   'inkpot_mdx'   
            \ ]

nnoremap \z   :<C-U>call z_menu#Main()<CR>

if has('win32') || has('win64')
    nnoremap <leader>`   :<C-U>call max_restore_win#Main()<CR>
endif

" }}}2

" [rainbowparentheses] "                           {{{2
nnoremap \rb :<C-U>RainbowParenthesesToggleAll<CR> 
"}}}2

" [yankring]"                                      {{{2
let g:yankring_min_element_length = 2
let yankring_history_dir          = g:vim_config_root
let g:yankring_history_file       = 'yankring_hist'
function! g:YRRunAfterMaps()
    nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction

nnoremap <leader>yr :<C-U>YRShow<CR>
"}}}2

" [delimitmate]"                                   {{{2
let delimitMate_expand_space       = 1
let delimitMate_expand_cr          = 1
let delimitMate_smart_quotes       = 1
let delimitMate_balance_matchpairs = 1
"}}}2

" [easytags]"                                      {{{2
set updatetime=4000
let g:easytags_updatetime_autodisable = 1
let g:easytags_include_members = 1
highlight cMember gui=italic
" highlight link cMember Special

if has('unix') || has('win32unix')
    let g:easytags_resolve_links = 1
endif

"}}}2

" [singlecompile]"                                 {{{2
nnoremap <F5> :<C-U>SCCompileRun<CR>
"}}}2

" [python-mode]"                                   {{{2
let g:pymode_doc_key  = '<leader>k'
let g:pymode_run_key  = '<leader>run'
let pymode_lint_onfly = 1
let pymode_breakpoint = '<leader>brk'
"}}}2

" [youcompleteme]"                                 {{{2
" nnoremap <leader>ycm :YcmForceCompileAndDiagnostics<CR>
let g:ycm_complete_in_strings                           = 1
let g:ycm_complete_in_comments                          = 1
let g:ycm_max_diagnostics_to_display                    = 14
let g:ycm_collect_identifiers_from_comments_and_strings = 1
" let g:ycm_add_preview_to_completeopt                  = 1
let g:ycm_complete_in_comments_and_strings              = 1
let g:ycm_autoclose_preview_window_after_completion     = 1
let g:ycm_autoclose_preview_window_after_insertion      = 1
let g:ycm_global_ycm_extra_conf                         = g:vim_config_root . '/neobundle/youcompleteme/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_filetypes_to_completely_ignore                = {}
let g:ycm_filetype_blacklist                            = {
      \ 'notes'    : 1,
      \ 'markdown' : 1,
      \ 'python'   : 1,
      \ 'vimwiki'  : 1
      \}
let g:ycm_filetype_whitelist                            = {
      \ '*'	   : 1
      \}
" let g:ycm_filetype_specific_completion_to_disable     = {}
let g:ycm_allow_changing_updatetime                     = 0
let g:ycm_register_as_syntastic_checker                 = 1
let g:ycm_seed_identifiers_with_syntax                  = 1
" let g:ycm_key_invoke_completion                       = '<C-Space>'
" let g:ycm_key_detailed_diagnostics                    = '<leader>d'
let g:ycm_key_list_select_completion                    = ['<Down>']
let g:ycm_key_list_previous_completion                  = ['<Up>']
"}}}2

" [nerdcomment]                                    {{{2
let NERDBlockComIgnoreEmpty       = 1
let NERDSpaceDelims               = 1
let NERDDefaultNesting            = 0
"let NERDCommentWholeLinesInVMode = 1
"let NERDLPlace                   = "[>"
"let NERDRPlace                   = "<]"
"let NERDCompactSexyComs          = 1
" let NERD_<filetype>_alt_style   = 1
"}}}2

" [ultisnips]                                      {{{2
let g:UltiSnipsEditSplit           = "horizontal"
let g:UltiSnipsExpandTrigger       = "<Tab>"
let g:UltiSnipsJumpForwardTrigger  = "<C-F>"
let g:UltiSnipsJumpBackwardTrigger = "<C-S>"
let g:UltiSnipsNoPythonWarning     = 1
let g:UltiSnipsSnippetsDir         = g:vim_config_root . '/neobundle/mudox_ultisnips/ultisnips_snippets'
let g:UltiSnipsSnippetDirectories  = [ "ultisnips_snippets" ]
"}}}2

" [pathogen]                                       {{{2
" call pathogen#infect() 
"}}}2

" [taglist]                                        {{{2
let Tlist_Show_One_File             = 1
let Tlist_Exit_OnlyWindow           = 1
if ! has("gui_running")
    let Tlist_Inc_Winwidth          = 0
endif
"}}}2

" [jedi]                                           {{{2
let g:jedi#pydoc                    = "<leader>k"
let g:jedi#popup_select_first       = 0
let g:jedi#auto_vim_configuration   = 0
let g:jedi#show_function_definition = 0
"}}}2

" [tagbar]                                         {{{2
nnoremap <leader>tb :TagbarToggle<CR>
" let g:tagbar_compact = 1
" let g:tagbar_indent = 1

if has('win32') || has('win64')
        let g:tagbar_iconchars = ['+', '-']
elseif has('unix')
        let g:tagbar_iconchars = ['▾', '▸']
elseif has('mac') || has('macunix')
        let g:tagbar_iconchars = ['▾', '▸']
else
    echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
endif

let g:tagbar_autoshowtag = 1
"}}}2

" [nerdtree]                                       {{{2

" close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let NERDTreeMinimalUI = 1 " No ? tips line, no bookmark headline.
" let NERDTreeSortOrder = ['\.vim$', '\.c$', '\.h$', '*', 'foobar']
" let NERDTreeWinPos = "left" or "right"
"}}}2

" [vimsignature]                                   {{{2
" nnoremap \s :SignatureToggle<CR>
" let g:SignaturePeriodicRefresh = 0
"}}}2

" [mark]                                           {{{2
let g:mwAutoSaveMarks = 0
" let g:mwHistAdd = '/@'
let g:mwIgnoreCase = 0
"}}}2

" [easymotion]                                     {{{2
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz12347890'
let g:EasyMotion_do_shade = 0
"}}}2

" [powerline]                                      {{{2
let g:Powerline_symbols        = 'fancy'
let g:Powerline_stl_path_style = 'filename'
let g:Powerline_mode_n         = 'N'
let g:Powerline_mode_i         = 'I'
let g:Powerline_mode_R         = 'R'
let g:Powerline_mode_v         = 'V'
let g:Powerline_mode_V         = 'VL'
let g:Powerline_mode_cv        = 'VB'
let g:Powerline_mode_s         = 'S'
let g:Powerline_mode_S         = 'SL'
let g:Powerline_mode_cs        = 'SB'
"}}}2

" [unite]                                          {{{2
nnoremap \mru :Unite -start-insert file_mru<CR>
nnoremap \bm  :Unite -vertical bookmark<CR>
nnoremap \mru :Unite -start-insert file_mru<CR>
nnoremap \ub  :Unite -vertical bookmark<CR>
" let g:unite_enable_start_inser = 1
" let g:unite_split_rule = 'topleft'
" let g:unite_enable_split_vertically
"}}}2

"}}}1

" EVENTS                                           {{{1

" Only highlights current line in the window which gets focus.
" autocmd WinEnter * set cursorline
" autocmd WinLeave * set nocursorline

" On a new Vim session, set CWD to the user's root path (i.e. expand("~"))
" and open NerdTree rooted on the user's root path.
autocmd VimEnter * exe "cd " . expand("~")
" autocmd VimEnter * exe "NERDTree " . expand("~") 
"}}}1

" ABBREVIATES                                      {{{1
cabbrev ue UltiSnipsEdit
cabbrev nt NERDTree
"}}}1

" DEFAULT COLORS                                   {{{1

" default popup menu colors
highlight Pmenu ctermbg=8 guibg=#140033
highlight PmenuSel ctermbg=1 guifg=#3D2466 guibg=#FF760D
" highlight PmenuSbar ctermbg=0 guibg=083308

" default signature column colors
hi SignColumn     gui=NONE   guifg=#8b8bcd   guibg=#2e2e2e

"}}}1

" SETTINGS                                         {{{1

" Important
set nocompatible

if has('win32') || has('win64')
        set guioptions=fegtaM
elseif has('unix')
        set guioptions=fgtaM
elseif has('mac') || has('macunix')
        set guioptions=fgtaM
else
    echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
endif

syntax on
filetype plugin indent on " 'filetype on' implied

set encoding=utf8

" color & font
set background=dark
call auto_colo#AutoColoRandom()  " random colorscheme 

if has('win32') || has('win64')
    set guifont=YaHei_Consolas_Hybrid:h10:cGB2312
elseif has('unix')
    set guifont=Ubuntu\ Mono\ for\ Powerline\ 12
elseif has('mac') || has('macunix')
    " set guifont=Ubuntu\ Mono\ for\ Powerline\ 12
else
    echohl ErrorMsg | echo "Oops! Unknown sysinfo" | echohl NONE
endif

set linespace=0

" Editor interface
set noshowmode   " powerline does better
set showcmd
set noruler      " powerline does better
set shortmess+=I " no intro text when start with an empty buffer.
set nocursorline
set laststatus=2 " always show status bar.

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
set listchars=tab:>+,eol:$
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
  let l:prefix = '★ '
  let l:foldline = l:prefix . l:sub. v:folddashes
  return l:foldline
endfunction

" Command line completion
set history=30
set wildmenu

if has('unix')
    set wildignorecase "
endif

" }}}1

" vim: foldmethod=marker fileformat=unix
