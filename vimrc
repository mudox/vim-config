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
    exe 'set runtimepath+=' . g:vim_config_root . '/neobundle/neobundle'
endif

call neobundle#rc(g:vim_config_root . '/neobundle')

" Let neobundle manage neobundle
NeoBundleFetch 'Shougo/neobundle.vim' , { 'name' : 'neobundle' }

" 'neobundle_config' below is a symbollink which refers to file under
" root/vimrc.d/neobundle.d/*
execute "source " . g:rc_root . '/vimrc.d/neobundle_config'

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

" function NeoUpdateLogs()
" let l:tmpFile = tempname()

" execute 'redi > ' . l:tmpFile

" NeoBundleUpdate
" NeoBundleUpdatesLog

" redi END

" silent execute mudox#query_open_file#Main() . ' ' . l:tmpFile
" endfunction

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

" PULGIN SETTINGS                                 {{{1

" [ctrlp-funky]                                      {{{2
nnoremap <C-P>f :<C-U>CtrlPFunky<CR>
" }}}2

" [easy_align]                                       {{{2
vnoremap <silent> <Enter> :EasyAlign<cr>
" }}}2

" [origami]                                          {{{2
let g:OrigamiPadding = 3
let g:OrigamiStaggeredSpacing = 3
" }}}2

" [airline]                                          {{{2
let g:airline_exclude_preview            = 1
let g:airline_detect_modified            = 1
let g:airline_detect_paste               = 1
let g:airline_detect_iminsert            = 1
let g:airline_powerline_fonts            = 1
let g:airline_theme                      = 'molokai'
let g:airline_whitespace_symbol          = '!'
let g:airline_branch_empty_message       = "I'm Mudox"
let g:airline_enable_branch              = 1
let g:airline_enable_syntastic           = 1
let g:airline_enable_tagbar              = 1
let g:airline_mode_map = {
            \ '__' : '-',
            \ 'n'  : 'N',
            \ 'i'  : 'I',
            \ 'R'  : 'R',
            \ 'c'  : 'C',
            \ 'v'  : 'V',
            \ 'V'  : 'V',
            \ '' : 'V',
            \ 's'  : 'S',
            \ 'S'  : 'S',
            \ '' : 'S',
            \ }
" airline-tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':p:t:.'
" }}}2

" [switch]                                           {{{2

" Alt+S
nnoremap ó :Switch<CR>
let g:switch_custom_definitions =
            \ [
            \   ['NeoBundle', 'NeoBundleLazy', 'NeoBundleDisable']
            \ ]
" }}}2

" [cltrp]                                            {{{2
let g:ctrlp_extensions = ['funky']
nnoremap <C-P>r :CtrlPMRUFiles<CR>

let g:ctrlp_match_window      = 'bottom , order:btt , min:5 , max:15 , results:15'
let g:ctrlp_working_path_mode = 'ra'
" let g:ctrlp_root_markers    = ['']
let g:ctrlp_show_hidden       = 0
" let g:ctrlp_custom_ignore   = ''
let g:ctrlp_follow_symlinks   = 1
let g:ctrlp_by_filename       = 1

" Single VCS, listing command does not list untracked files:
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']
let g:ctrlp_user_command = ['.hg', 'hg --cwd %s locate -I .']

" }}}2

" [python_syntax]"                                   {{{2
let g:python_highlight_all = 1
" }}}2

" [zoomwintab]"                                      {{{2
" <M-O/o> to invoke :ZoomWinTabToggle
nnoremap ï :ZoomWinTabToggle<CR>
nnoremap Ï :ZoomWinTabToggle<CR>
" }}}2

" [vim-session]"                                     {{{2
" let g:session_autosave = 0
" let g:session_directory = '~/.vim_session'
" }}}2

" [ft-sql]"                                          {{{2
let g:ftplugin_sql_omni_key_right = '<C-l>'
let g:ftplugin_sql_omni_key_left  = '<C-h>'
"}}}2

" [dbext]"                                           {{{2

let g:dbext_default_buffer_lines          = 10
let g:dbext_default_use_sep_result_buffer = 0
let g:dbext_default_history_file          = '~/.dbext_sql_history'
let g:dbext_default_autoclose             = 0
let g:dbext_default_display_cmd_line      = 0

" Sqlite3 specific settings.
let g:dbext_default_SQLITE_bin            = 'sqlite3'
let g:dbext_default_SQLITE_cmd_header     = ".mode column\n.headers on\n"

" SQLITE3 profiles.
let s:profile_config_list                 = [
            \ 'type=SQLITE',
            \ 'SQLITE_bin=sqlite3',
            \ "cmd_terminator=';'",
            \ 'dbname=/home/mudox/Git/GwaMan/Gwa.db'
            \ ]
let g:dbext_default_profile_GwaMan = join(s:profile_config_list, ':')

" }}}2

" [matchparen]"                                      {{{2
let loaded_matchparen = 1
" }}}2

" [cottidie]"                                        {{{2
command! Tips CottidieTip
" }}}2

" [vimproc]"                                         {{{2
nnoremap <leader><leader>s :VimProcBang<Space>
" }}}2

" [goldenview]"                                      {{{2
let g:goldenview__enable_default_mapping = 0
" }}}2

" [surround]"                                        {{{2
xmap ' <Plug>VSurround'
xmap " <Plug>VSurround"
xmap ( <Plug>VSurround(
xmap ) <Plug>VSurround)
xmap { <Plug>VSurround{
xmap } <Plug>VSurround}
" xmap [ S[
" xmap ] S]
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

" [syntastic]"                                       {{{2
nnoremap <leader>ck :<C-U>SyntasticCheck<CR>

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
            \ 'active_filetypes': ['ruby', 'php', 'javascript'],
            \ 'passive_filetypes': ['puppet']
            \ }

" checker options
let g:syntastic_c_checkers = ['ycm']
let g:syntastic_cpp_checkers = ['ycm']
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_python_checkers = ['python', 'pyflakes', 'pep8']

" }}}2

" [vimwiki]"                                         {{{2
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

" [color: kolor]"                                    {{{2
let g:kolor_italic=1                    " Enable italic. Default: 1
let g:kolor_bold=1                      " Enable bold. Default: 1
let g:kolor_underlined=1                " Enable underline for 'Underlined'. Default: 0
let g:kolor_alternative_matchparen=1    " Gray 'MatchParen' color. Default: 0
" }}}2

" [textobj-comment]"                                 {{{2
let g:textobj_comment_no_default_key_mappings = 1
xmap ax <Plug>(textobj-comment-a)
omap ax <Plug>(textobj-comment-a)
xmap ix <Plug>(textobj-comment-i)
omap ix <Plug>(textobj-comment-i)
xmap aX <Plug>(textobj-comment-big-a)
omap aX <Plug>(textobj-comment-big-a)
" }}}2

" [indentline]                                       {{{2
nnoremap <leader>il :<C-U>IndentLinesToggle<CR>
let g:indentLine_enabled = 0
let g:indentLine_fileType = [
            \ 'c',
            \ 'cpp',
            \ 'python',
            \ 'make'
            \ ]
let g:indentLine_fileTypeExclude = [
            \ 'text',
            \ 'help',
            \ ''
            \]
let g:indentLine_bufNameExclude = [
            \ 'h_.*',
            \ 'hNERD_tree.*',
            \ '.*\doc\.txt'
            \]

" let g:indentLine_char = '.'
" let g:indentLine_color_term = 239
" let g:indentLine_color_gui = '#389900'
" }}}2

" [mudox]"                                           {{{2
nnoremap \cc  :<C-U>call mudox#auto_colo#AutoColoRandomAfter()<CR>
nnoremap \z   :<C-U>call mudox#z_menu#Main()<CR>
nnoremap \sm  :<C-U>call mudox#scripts_man#LoadingStatus()<CR>

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

" [yankring]"                                        {{{2
let g:yankring_min_element_length = 2
let yankring_history_dir          = g:vim_config_root
let g:yankring_history_file       = 'yankring_hist'
let yankring_replace_n_nkey       = '<Down>'
let yankring_replace_n_pkey       = '<Up>'

nnoremap <leader>yr :<C-U>YRShow<CR>
"}}}2

" [delimitmate]"                                     {{{2
let delimitMate_expand_space       = 1
let delimitMate_expand_cr          = 1
let delimitMate_smart_quotes       = 1
let delimitMate_balance_matchpairs = 1
"}}}2

" [easytags]"                                        {{{2
set updatetime=4000
let g:easytags_updatetime_autodisable = 1
let g:easytags_include_members = 1
highlight cMember gui=italic
" highlight link cMember Special

if has('unix') || has('win32unix')
    let g:easytags_resolve_links = 1
endif

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

" [youcompleteme]"                                   {{{2
" let g:ycm_collect_identifiers_from_tags_files           = 1
" let g:ycm_collect_identifiers_from_comments_and_strings = 1
" let g:ycm_seed_identifiers_with_syntax                  = 1

let g:ycm_complete_in_strings                           = 1
let g:ycm_complete_in_comments                          = 1

let g:ycm_max_diagnostics_to_display                    = 14
" let g:ycm_add_preview_to_completeopt                  = 1
let g:ycm_complete_in_comments_and_strings              = 1
let g:ycm_autoclose_preview_window_after_completion     = 1
let g:ycm_autoclose_preview_window_after_insertion      = 1
let g:ycm_global_ycm_extra_conf                         = g:vim_config_root . '/neobundle/youcompleteme/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_filetypes_to_completely_ignore                = {}
let g:ycm_filetype_blacklist                            = {
            \ 'notes'    : 1,
            \ 'markdown' : 1,
            \ 'vimwiki'  : 1,
            \ 'unite'    : 1
            \}
" let g:ycm_filetype_whitelist                            = {
            " \ '*'          : 1
            " \}
" let g:ycm_filetype_specific_completion_to_disable     = {}
let g:ycm_allow_changing_updatetime                     = 0
let g:ycm_register_as_syntastic_checker                 = 1
" let g:ycm_key_invoke_completion                       = '<C-Space>'
" let g:ycm_key_detailed_diagnostics                    = '<leader>d'
let g:ycm_key_list_select_completion                    = ['<Down>']
let g:ycm_key_list_previous_completion                  = ['<Up>']
"}}}2

" [nerdcomment]                                      {{{2
let NERDBlockComIgnoreEmpty       = 1
let NERDSpaceDelims               = 1
let NERDDefaultNesting            = 0
"let NERDCommentWholeLinesInVMode = 1
"let NERDLPlace                   = "[>"
"let NERDRPlace                   = "<]"
"let NERDCompactSexyComs          = 1
" let NERD_<filetype>_alt_style   = 1
"}}}2

" [ultisnips]                                        {{{2
let g:UltiSnipsEditSplit           = "horizontal"
let g:UltiSnipsExpandTrigger       = "<Tab>"
let g:UltiSnipsJumpForwardTrigger  = "<C-F>"
let g:UltiSnipsJumpBackwardTrigger = "<C-S>"
let g:UltiSnipsNoPythonWarning     = 1
let g:UltiSnipsSnippetsDir         = g:vim_config_root . '/neobundle/mudox_ultisnips/ultisnips_snippets'
let g:UltiSnipsSnippetDirectories  = [ "ultisnips_snippets" ]
"}}}2

" [pathogen]                                         {{{2
" call pathogen#infect()
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

" [tagbar]                                           {{{2
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

" [nerdtree]                                         {{{2

" close vim if the only window left open is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let NERDTreeMinimalUI = 1 " No ? tips line, no bookmark headline.
" let NERDTreeSortOrder = ['\.vim$', '\.c$', '\.h$', '*', 'foobar']
" let NERDTreeWinPos = "left" or "right"
"}}}2

" [vimsignature]                                     {{{2
" nnoremap \s :SignatureToggle<CR>
" let g:SignaturePeriodicRefresh = 0
"}}}2

" [mark]                                             {{{2
let g:mwAutoSaveMarks = 0
let g:mwIgnoreCase = 0
" let g:mwHistAdd = '/@'
"}}}2

" [easymotion]                                       {{{2
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz12347890'
let g:EasyMotion_do_shade = 0
"}}}2

" [powerline]                                        {{{2
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

" EVENTS                                          {{{1

" Only highlights current line in the window which gets focus.
" autocmd WinEnter * set cursorline
" autocmd WinLeave * set nocursorline

" On a new Vim session, set CWD to the user's root path (i.e. expand("~"))
" and open NerdTree rooted on the user's root path.
autocmd VimEnter * exe "cd " . expand("~")
" autocmd VimEnter * exe "NERDTree " . expand("~")
"}}}1

" ABBREVIATES                                     {{{1
cabbrev ue UltiSnipsEdit
cabbrev nt NERDTree
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
call mudox#auto_colo#AutoColoRandomRC()  " random colorscheme

if has('win32') || has('win64')
    set guifont=YaHei_Consolas_Hybrid:h10:cGB2312
    set linespace=0
    autocmd ColorScheme * set linespace=0
elseif has('unix')
    " under infinality style: winxp
    set guifont=Ubuntu\ Mono\ for\ Powerline\ 11.5
    set linespace=0
    autocmd ColorScheme * set linespace=0
elseif has('mac') || has('macunix')
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
set laststatus=2 " always show status bar.
set cmdheight=2

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
set hidden " don't unload a buffer when no longer shown in a window.
"}}}2

" vim files syntax hightlighting                     {{{2
let g:vimsyn_embed = 0      " disable all embeding syntax.
let g:vimsyn_folding = 'af' " enable autofolding of autogroups & functions.
let g:vimsyn_noerror = 1
"}}}2

"}}}1

" vim: foldmethod=marker fileformat=unix foldmethod=marker
