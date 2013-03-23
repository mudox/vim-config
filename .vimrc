" .vimrc for [G]Vim on Linux

" NEOBUNDLE {{{1
set nocompatible                " Recommend

if has('vim_starting')
    set runtimepath+=~/.vim/neobundle/neobundle
endif

" Use https protocol over proxy.
" let g:neobundle#types#git#default_protocol = 'https'

call neobundle#rc(expand('~/.vim/neobundle'))

" Let neobundle manage neobundle
NeoBundleFetch 'Shougo/neobundle.vim', { 'name' : 'neobundle' }

" Use neobundle standard recipes.
NeoBundle 'Shougo/neobundle-vim-scripts'

" My Bundles here: {{{2
" [Vimproc]
NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \        'windows' : 'make -f make_mingw32.mak',
            \        'cygwin'  : 'make -f make_cygwin.mak',
            \        'mac'     : 'make -f make_mac.mak',
            \        'unix'    : 'make -f make_unix.mak',
            \    },
            \ }
" [Vimfiler]
NeoBundle 'Shougo/vimfiler', { 'depends' : 'Shougo/unite.vim' }
" [Unite]
NeoBundle 'Shougo/unite.vim', { 'name' : 'unite' }
" [clang_complete]
NeoBundleLazy 'Rip-Rip/clang_complete', {
            \   'autoload' : {
            \       'filetypes' : ['c', 'cpp'],
            \   },
            \ }
" [Vimshell]
NeoBundleLazy 'Shougo/vimshell',{
            \     'depends' : 'Shougo/vimproc',
            \     'autoload' : {
            \       'commands' : [
            \           { 
            \               'name' : 'VimShell',
            \               'complete' : 'customlist,vimshell#complete'
            \           },
            \           'VimShellExecute', 'VimShellInteractive',
            \           'VimShellTerminal', 'VimShellPop'
            \       ],
            \       'mappings' : [ '<Plug>(vimshell_switch)' ]
            \     }
            \ }
" [Mudox-vim-scripts]
NeoBundle 'Mudox/mudox-vim-scripts'
" [delimitMate]
NeoBundle 'Raimondi/delimitMate', { 'name' : 'delimitmate' }
" [Easytags]
NeoBundle 'xolox/vim-easytags', { 'name' : 'easytags' }
" [Vim-textobj-syntax]
NeoBundle 'kana/vim-textobj-syntax', { 'name' : 'text-ojbect-syntax' }
" [Vim-textobj-function]
NeoBundle 'kana/vim-textobj-function', { 'name' : 'textobj-function' }
" [Vim-textobj-entire]
NeoBundle 'kana/vim-textobj-entire', { 'name' : 'textobj-entire' }
" [Vim-textobj-indent]
NeoBundle 'kana/vim-textobj-indent', { 'name' : 'textobj-indent' }
" [Vim-textobj-line]
NeoBundle 'kana/vim-textobj-line', { 'name' : 'textobj-line' }
" [Vim-textobj-user]
NeoBundle 'kana/vim-textobj-user', { 'name' : 'textobj-user' }
" [Nrrwrgn]
NeoBundle 'chrisbra/NrrwRgn', { 'name' : 'nrrwrgn' }
" [Repeat]
NeoBundle 'tpope/vim-repeat', { 'name' : 'repeat' }
" [Unimpaired]
NeoBundle 'tpope/vim-unimpaired', { 'name' : 'unimpaired' }
" [Abolish]
NeoBundle 'tpope/vim-abolish', { 'name' : 'abolish' }
" [Textobj-word-column]
NeoBundle 'coderifous/textobj-word-column.vim'
" [Zoomwintab]
NeoBundle 'troydm/zoomwintab.vim'
" [singlecompile]
NeoBundle 'xuhdev/SingleCompile', { 'name' : 'singlecompile' }
" [hardmode]
NeoBundle 'wikitopian/hardmode'
" [yankring]
NeoBundle 'vim-scripts/YankRing.vim', { 'name' : 'yankring' }
" [python-mode]
NeoBundle 'klen/python-mode'
" [vimwiki]
NeoBundle 'vim-scripts/vimwiki'
" [flake8]
NeoBundle 'nvie/vim-flake8', { 'name' : 'flake8' }
" [rainbow_parentheses]
NeoBundle 'kien/rainbow_parentheses.vim'
" [YouCompleteMe]
NeoBundle 'Valloric/YouCompleteMe', {
            \   'name' : 'youcompleteme',
            \   'build': {
            \        'unix' : './install.sh --clang-completer'
            \   }
            \ }
" [Syntastic]
NeoBundle 'scrooloose/syntastic' 
" [MatchTagAlways]
NeoBundle 'Valloric/MatchTagAlways', { 'name' : 'matchtagsalways' }
" [jedi]-vim
NeoBundle 'davidhalter/jedi-vim'
" [FSwitch]
NeoBundle 'vim-scripts/FSwitch', { 'name' : 'fswitch' }
" [ColorV] related
NeoBundle 'mattn/webapi-vim' 
NeoBundle 'Rykka/colorv.vim'
NeoBundle 'Rykka/galaxy.vim'
" [Powerline]
NeoBundle 'Lokaltog/vim-powerline', { 'name' : 'powerline' }
" [NerdCommenter]
NeoBundle 'scrooloose/nerdcommenter' 
" [NerdTree]
NeoBundle 'scrooloose/nerdtree' 
" [vim]-signature
NeoBundle 'kshenoy/vim-signature', { 'name' : 'signature' }
" [UltiSnips]
NeoBundle 'SirVer/ultisnips'
" [EasyMotion]
NeoBundle 'Lokaltog/vim-easymotion', { 'name' : 'easymotion' }
" [Vim-Indent-Guides]
NeoBundle 'mutewinter/vim-indent-guides', { 'name' : 'indent-guides' }
" [TagList]
NeoBundle 'vim-scripts/taglist.vim'        
" [TagBar]
NeoBundle 'majutsushi/tagbar'            
" [SrcExpl]
NeoBundle 'wesleyche/SrcExpl', { 'name' : 'srcexpl' }
" [BufExplorer]
NeoBundle 'vim-scripts/bufexplorer.zip', { 'name' : 'bufexplorer' }
" [Fugitive]
NeoBundle 'tpope/vim-fugitive', { 'name' : 'fugitive' }
" [Surround]
NeoBundle 'tpope/vim-surround', { 'name' : 'surround' }
" [Align]
NeoBundle 'vim-scripts/Align', { 'name' : 'align' }
" [NeoComplCache]
" NeoBundle 'Shougo/neocomplcache' 
" [SuperTab]
" NeoBundle 'ervandew/supertab' 
" [OmniCppComplete]
" NeoBundle 'vim-scripts/OmniCppComplete'  
" [AutoComplPop]
" NeoBundle 'vim-scripts/AutoComplPop'     
" [AutoPairs]
" NeoBundle 'jiangmiao/auto-pairs'         
" [AutoAlign]
" NeoBundle 'vim-scripts/AutoAlign'
"}}}2

filetype plugin indent on       " Required!

" Installation check.
NeoBundleCheck

if !has('vim_starting')
    " Call on_source hook when reloading .vimrc.
    call neobundle#call_hook('on_source')
endif
"}}}1

" FROM SAMPLE FILE {{{1

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

" SETTINGS {{{1

" Important
set nocp
set guioptions=fgtaM
syntax on
filetype plugin indent on " 'filetype on' implied

set encoding=utf8

" color & font
call auto_colo#AutoColoRandom()
set guifont=Ubuntu\ Mono\ 12

" Editor interface
set noshowmode " powerline does better 
set showcmd
set noruler " powerline does better 
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
set noautochdir " for VimShell to work 
set sessionoptions=buffers,folds,globals,help,localoptions,options,resize,sesdir,slash,tabpages,unix,winpos,winsize
set autowriteall
set viminfo+=!  " save global variables in viminfo files 

" Insert behaviour
set whichwrap=b,s,<,>,[,],h,l
set backspace=indent,eol,start
set completeopt=menu
set dictionary+=/usr/share/dict/words 
" Fold line text
set foldtext=MyFoldText()
function! MyFoldText()
  let line = getline(v:foldstart)
  let sub = substitute(line, '/\*\|\*/\|{\{3}.*', '', 'g')
  return sub . v:folddashes
endfunction

" Command line completion
set history=30
set wildmenu
set wildignorecase " *nix platform only

" }}}1

" MAPPINGS {{{1

" Default leader key for <leader> mappings
let g:mapleader = ','

nnoremap \z   :call z_menu#Main()<CR>

map <Up> gk
map <Down> gj

" Ctrl + h / j / k / l to jump among windows  {{{2
nnoremap <C-H>	   <C-W>h
nnoremap <C-J>	   <C-W>j
nnoremap <C-K>	   <C-W>k
nnoremap <C-L>	   <C-W>l
"}}}2
" Ctrl + Shift + Arrow Keys to resize windows {{{2
nnoremap <C-S-Up> 		5<C-W>+
nnoremap <C-S-Down> 	5<C-W>-
nnoremap <C-S-Left> 	5<C-W>< 
nnoremap <C-S-Right> 	5<C-W>>
"}}}2
" Ctrl + Alt + Left / Right Arrow to move tabs {{{2
nnoremap <silent> <M-C-Left> :if tabpagenr() == 1\|exe "tabm ".tabpagenr("$")\|el\|exe "tabm ".(tabpagenr()-2)\|en<CR>
nnoremap <silent> <M-C-Right> :if tabpagenr() == tabpagenr("$")\|tabm 0\|el\|exe "tabm ".tabpagenr()\|en<CR>
"}}}2
" Atl + Left / Right Arrow to switch among tabs {{{2
nnoremap <silent> <M-Left> gT
nnoremap <silent> <M-Right> gt
"}}}2
" Ctr + Left / Right Arrow to switch current buffer {{{2
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

" My new line scheme
" nnoremap OO O
" nnoremap Oj mpo<Esc>0d$`p
" nnoremap Ok mpO<Esc>0d$`p

" Toggle tab line
nnoremap \t :exe "set showtabline=" . (&showtabline+1)%2<CR>

" Toggle vim-signature plugin
nnoremap \s :SignatureToggle<CR>

" key q is too easy to touch, but is needed infrequently
nnoremap q <Nop>
nnoremap _q q

noremap zi zizz
" Move in insert mode 
inoremap <C-H> <Left>
inoremap <C-L> <Right>

" }}}1

" PULGIN SETTINGS {{{1

" [easytags]"{{{
set updatetime=4000
"}}}

" [clangcomplete]"{{{
" let g:clang_hl_errors = 1
let g:clang_complete_copen = 1
let g:clang_complete_auto = 1
let g:clang_periodic_quickfix = 1
let g:clang_snippets = 1
let g:clang_close_preview = 1
let g:clang_snippets_engine = 'ultisnips'
" let g:clang_trailing_placeholder = 1
" let g:clang_user_options = '-std=c++11'
" let g:clang_auto_user_options
" let g:clang_compilation_database
" let g:clang_use_library = 1
" let g:clang_library_path = ""
" let g:clang_sort_algo = "priority"
" let g:clang_complete_macros = 0
" let g:clang_complete_patterns = 0
"}}}

" [singlecompile]"{{{
nnoremap <F5> :<C-U>SCCompileRun<CR>
"}}}

" [python-mode]"{{{
let g:pymode_doc_key  = '<leader>k'
let g:pymode_run_key  = '<leader>run'
let pymode_lint_onfly = 1
let pymode_breakpoint = '<leader>brk'
"}}}

" [youcompleteme]"{{{
nnoremap <leader>ycm :YcmForceCompileAndDiagnostics<CR>
let g:ycm_add_preview_to_completeopt                = 1
let g:ycm_complete_in_comments_and_strings          = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_list_select_completion                = ['<Down>']
let g:ycm_key_list_previous_completion              = ['<Up>']
" let g:ycm_key_invoke_completion                   = '<C-Space>'
" let g:ycm_key_detailed_diagnostics                = '<leader>d'
let g:ycm_global_ycm_extra_conf                     = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_filetypes_to_completely_ignore            = {}
let g:ycm_filetype_blacklist                        = {
      \ 'notes'    : 1,
      \ 'markdown' : 1,
      \ 'python'   : 1,
      \ 'cpp'      : 1, 
      \}
" let g:ycm_filetype_whitelist                      = {
      " \ '*'      : 1,
      " \}
let g:ycm_allow_changing_updatetime = 0
"}}}

" [nerdcomment]{{{2
let NERDBlockComIgnoreEmpty       = 1
let NERDSpaceDelims               = 1
let NERDDefaultNesting            = 0
"let NERDCommentWholeLinesInVMode = 1
"let NERDLPlace                   = "[>"
"let NERDRPlace                   = "<]"
"let NERDCompactSexyComs          = 1
" let NERD_<filetype>_alt_style   = 1
"}}}2

" [autopairs]{{{2
" let g:AutoPairsFlyMode = 1
" let g:AutoPairsShortcutBackInsert = '<M-b>' 
"}}}2

" [ultisnips]{{{2
let g:UltiSnipsEditSplit             = "horizontal"
" let g:UltiSnipsExpandTrigger       = "<tab>"
" let g:UltiSnipsJumpForwardTrigger  = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsNoPythonWarning       = 1
let g:UltiSnipsSnippetsDir           = "~/.vim/MdxUltiSnips/"
let g:UltiSnipsSnippetDirectories    = [ "MdxUltiSnips" ]
"}}}2

" [pathogen]{{{2
call pathogen#infect() 
"}}}2

" [taglist]{{{2
let Tlist_Show_One_File             = 1
let Tlist_Exit_OnlyWindow           = 1
if ! has("gui_running")
    let Tlist_Inc_Winwidth          = 0
endif
"}}}2

" [jedi]{{{2
let g:jedi#pydoc                    = "<leader>k"
let g:jedi#popup_select_first       = 0
let g:jedi#auto_vim_configuration   = 0
let g:jedi#show_function_definition = 0
"}}}2

" [tagbar]{{{2
nnoremap <leader>tb :TagbarToggle<CR>
" let g:tagbar_compact = 1
" let g:tagbar_indent = 1
let g:tagbar_iconchars = ['▾', '▸']
let g:tagbar_autoshowtag = 1
" let g:tagbar_iconchars = ['+', '-']
" let g:tagbar_systemenc = 'cp936'
"}}}2

" [nerdtree]{{{2

" close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let NERDTreeMinimalUI = 1 " No ? tips line, no bookmark headline.
" let NERDTreeSortOrder = ['\.vim$', '\.c$', '\.h$', '*', 'foobar']
" let NERDTreeWinPos = "left" or "right"
"}}}2

" [vimsignature]{{{2
let g:SignaturePeriodicRefresh = 0
"}}}2

" [mark]{{{2
let g:mwAutoSaveMarks = 0
" let g:mwHistAdd = '/@'
let g:mwIgnoreCase = 0
"}}}2

" [easymotion]{{{2
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz12347890'
let g:EasyMotion_do_shade = 0
"}}}2

" [powerline]{{{2
let g:Powerline_symbols        = 'fancy'
" let g:Powerline_colorscheme  = 'solarized'
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

" [unite]{{{2
nnoremap \mru :Unite -start-insert file_mru<CR>
nnoremap \bm  :Unite -vertical bookmark<CR>
nnoremap \mru :Unite -start-insert file_mru<CR>
nnoremap \ub  :Unite -vertical bookmark<CR>
" let g:unite_enable_start_inser = 1
" let g:unite_split_rule = 'topleft'
" let g:unite_enable_split_vertically
"}}}2

" " [omnicppcomplete]{{{2
" let OmniCpp_NamespaceSearch = 2
" let OmniCpp_DisplayMode = 1 " always show members 
" let OmniCpp_ShowScopeInAbbr = 0
" let OmniCpp_ShowPrototypeInAbbr = 1
" let OmniCpp_ShowAccess = 1
" let OmniCpp_DefaultNamespaces = ["std"]
" let OmniCpp_MayCompleteScope = 1
" let OmniCpp_MayCompleteArrow = 1
" let OmniCpp_MayCompleteDot   = 1
" let OmniCpp_LocalSearchDecl  = 1

" "}}}2

" " [autocomplpop]{{{2
" " let g:acp_enableAtStartup = 0 " disable acp at startup 
" " " let g:acp_mappingDriven = 0
" " let g:acp_ignorecaseOption = 1
" " let g:acp_behaviorSnipmateLength = 1
" " " let g:acp_completeOption = '.,w,b,k'
" " let g:acp_completeoptPreview = 1
" " let g:acp_behaviorKeywordLength = 3
" " " let g:acp_behaviorKeywordIgnores = []
" " " let g:acp_behaviorRubyOmniMethodLength = 0
" " " let g:acp_behaviorPythonOmniLength = 0
" "}}}2

" " [supertab]{{{2
" " let g:SuperTabDefaultCompletionType    = "context"
" " let g:SuperTabMappingForward           = '<C-J>'
" " let g:SuperTabMappingBackward          = '<C-K>'
" " let g:SuperTabLongestEnhanced          = 1
" " let g:SuperTabLongestHighlight         = 1
" " let g:SuperTabClosePreviewOnPopupClose = 1
" "}}}2

" " [neocomplcache]{{{2

    " "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!

    " " Use neocomplcache.
    " let g:neocomplcache_enable_at_startup = 0

    " " Use smartcase.
    " let g:neocomplcache_enable_smart_case = 1

    " " Set minimum syntax keyword length.
    " let g:neocomplcache_min_syntax_length = 3
    " let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

    " " Enable heavy features.
    " " Use camel case completion.
    " " let g:neocomplcache_enable_camel_case_completion = 1

    " " Use underbar completion.
    " " let g:neocomplcache_enable_underbar_completion = 1

    " let g:neocomplcache_enable_auto_close_preview = 0

    " " Fuzzy matching
    " let g:neocomplcache_enable_fuzzy_completion = 1
    " let g:neocomplcache_fuzzy_completion_start_length = 3

    " " Define dictionary.
    " let g:neocomplcache_dictionary_filetype_lists = {
        " \ 'default' : '',
        " \ 'vimshell' : $HOME . '/.vimshell_hist',
        " \ 'scheme' : $HOME . '/.gosh_completions'
        " \ }

    " " Define keyword.
    " if !exists('g:neocomplcache_keyword_patterns')
        " let g:neocomplcache_keyword_patterns = {}
    " endif
    " let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

    " " Plugin key-mappings.
    " inoremap <expr><C-g>     neocomplcache#undo_completion()
    " inoremap <expr><C-l>     neocomplcache#complete_common_string()

    " " Recommended key-mappings.
    " " Close popup by <Space>.
    " inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() ."\<Space>" : "\<Space>"

    " " <CR> behaviour:
    " " When menu popped up, insert selected candidate word followed with a new
    " " line, otherwise behave as it is.
    " inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    " function! s:my_cr_function()
      " return neocomplcache#close_popup() . "\<CR>"
      " " For no inserting <CR> key.
      " "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
    " endfunction

    " " <TAB>: completion.
    " inoremap <expr><TAB>  pumvisible() ? "\<C-N>" : "\<TAB>"
    " inoremap <C-J>  <C-N>
    " inoremap <C-K>  <C-P>

    " " <C-h>, <BS>: close popup and delete backword char.
    " inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    " inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    " inoremap <expr><C-y>  neocomplcache#close_popup()
    " inoremap <expr><C-e>  neocomplcache#cancel_popup()

    " " For cursor moving in insert mode(Not recommended)
    " "inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
    " "inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
    " "inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
    " "inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
    " " Or set this.
    " "let g:neocomplcache_enable_cursor_hold_i = 1
    " " Or set this.
    " "let g:neocomplcache_enable_insert_char_pre = 1

    " " AutoComplPop like behavior.
    " " let g:neocomplcache_enable_auto_select = 1

    " " Shell like behavior(not recommended).
    " "set completeopt+=longest
    " "let g:neocomplcache_enable_auto_select = 1
    " "let g:neocomplcache_disable_auto_complete = 1
    " "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

    " " Enable omni completion.
    " autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    " autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    " autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " " Enable heavy omni completion.
    " if !exists('g:neocomplcache_omni_patterns')
      " let g:neocomplcache_omni_patterns = {}
    " endif
    " let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
    " "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    " let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    " let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    " let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " " For perlomni.vim setting.
    " " https://github.com/c9s/perlomni.vim
    " let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" " "}}}2

"}}}1

" EVENTS {{{1

" Only highlights current line in the window which gets focus.
" autocmd WinEnter * set cursorline
" autocmd WinLeave * set nocursorline

" On a new Vim session, set CWD to the user's root path (i.e. expand("~"))
" and open NerdTree rooted on the user's root path.
autocmd VimEnter * exe "cd " . expand("~")
" autocmd VimEnter * exe "NERDTree " . expand("~") 
"}}}1

" ABBREVIATES {{{1
cabbrev ue UltiSnipsEdit
cabbrev nt NERDTree
cabbrev ac AlignCtrl
cabbrev al Align
"}}}1

" DEFAULT COLORS {{{1

" default popup menu colors
highlight Pmenu ctermbg=8 guibg=#140033
highlight PmenuSel ctermbg=1 guifg=#3D2466 guibg=#FF760D
" highlight PmenuSbar ctermbg=0 guibg=083308

" default signature column colors
hi SignColumn     gui=NONE   guifg=#8b8bcd   guibg=#2e2e2e

"}}}1

" vim: foldmethod=marker fileformat=unix
