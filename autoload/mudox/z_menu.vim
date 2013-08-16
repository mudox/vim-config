" File: z_menu.vim
" Author: Mudox
" Description: open and edit VIMRCs in various way.
" Last Modified: March 09, 2013

if exists('g:did_z_menu_dot_vim')
    finish
else
    let g:did_z_menu_dot_vim = expand('<sfile>:p')
endif

" ------------------------------------------------------------------------------

function! s:EchoError( msg )
    echohl ErrorMsg
    echo  a:msg
    echohl None
endfunction

" open $MDX_VIMRC_0 in a user preferred way.
function! s:EditVIMRC()
    execute mudox#query_open_file#Main() . " " . g:vim_config_root . "/vimrc"
endfunction

" open this script in a user preferred way.
function! s:EditMudoxVim()
    execute mudox#query_open_file#Main() . " " . substitute(g:did_z_menu_dot_vim, ' ', '\\ ', 'g')
endfunction

" Make a GRE view.
function! s:GREView()
    cd $MDX_DROPBOX/TEXT.DROP/vocabulary/ymh\ gre/
    tabnew gre_ymh.txt
    botright vnew tough_words.txt
    rightbelow new confusion.txt
    so mm.vim
endfunction

" Make a LYN view.
function! s:LYNView()
    cd $MDX_DROPBOX/TEXT.DROP/vocabulary/lyn\ 5500/
    tabnew lyn5500.txt
    botright vnew rule.txt
    so ../ymh\ gre/mm.vim
endfunction

function! mudox#z_menu#Main()
    let l:actions = [
                \ function('s:EditVIMRC')    , 
                \ function('s:GREView')       , 
                \ function('s:LYNView')       , 
                \ function('s:EditMudoxVim')
                \ ]

    let l:prompt = "*------------------- Hello Mudox -------------------- \n" .
                \  "[0] - Edit $MDX_VIMRC_0 in current window.\n" .
                \  "[1] - Learn GRE.\n" .
                \  "[2] - Learn LYN.\n" .
                \  "[3] - Edit mudox-vim scripts.\n" .
                \  "*---------------------------------------------------- \n" .
                \  "Give your choise by number(empty to cancel): " 

    while 1
        let l:opt = input(l:prompt)

        if l:opt =~ '^\s*$'
            echo 'Canceled'
            return
        elseif index(range(len(l:actions)), l:opt + 0) != -1
            call l:actions[l:opt]()
            return
        else
            echohl ErrorMsg 
            echo  "Invalid input"
            echohl None
        endif
    endwhile
endfunction
