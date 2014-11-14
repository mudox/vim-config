let s:max_lines = 0
let s:max_columns = 0
let s:old_xpos = 340
let s:old_ypos = 280
set lines=25
set columns=80

function! mudox#max_restore_win#Main()
    if  s:max_lines == 0 && s:max_columns == 0
        " if on the first run.
        let s:old_lines = &lines
        let s:old_columns = &columns

        let &lines = 9999
        let &lines = &lines - 1
        let &columns = 9999
        winpos 0 0

        let s:max_lines = &lines
        let s:max_columns = &columns

        if s:old_lines == &lines && s:old_columns == &columns
            " if it is maximized initially.
            " set lines and columns to it gui default values.
            call RestoreWin()
        endif

    else
        " not the first run.
        if &lines == s:max_lines && &columns == s:max_columns
            call RestoreWin()
        else
            call MaximizeWin()
        endif
    endif

    exe "normal \<C-W>="
endfunction

function! MaximizeWin()
    let s:old_lines = &lines
    let s:old_columns = &columns
    let s:old_xpos = getwinposx()
    let s:old_ypos = getwinposy()

    let &columns = 9999
    let &lines = 9999
    let s:max_lines = &lines - 1
    let s:max_columns = &columns
    let &lines = s:max_lines

    winpos 0 0
endfunction

function! RestoreWin()
    exe "set lines=" . s:old_lines
    exe "set columns=" . s:old_columns
    exe "winpos " . s:old_xpos . " " . s:old_ypos
endfunction
