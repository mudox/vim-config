if !exists('g:loaded_color_toy_options')
    let g:loaded_color_toy_options = 1
endif

if !exists('g:color_toy_config_file')
    let g:color_toy_config_file = '~/.vim_color_toy'
endif

function! mudox#color_toy_options#Load()
    if filereadable(expand(g:color_toy_config_file))
        let g:saved = readfile(expand(g:color_toy_config_file), '', 9)

        " verify the content
        if !
                    \ g:saved[0] =~ '^mode\%(:\f\+\)*$' &&
                    \ g:saved[1] =~ '^gvwl\%(:\f\+\)*$' &&
                    \ g:saved[1] =~ '^gvbl\%(:\f\+\)*$' &&
                    \ g:saved[1] =~ '^tvwl\%(:\f\+\)*$' &&
                    \ g:saved[1] =~ '^tvbl\%(:\f\+\)*$' &&
                    \ g:saved[1] =~ '^gawl\%(:\f\+\)*$' &&
                    \ g:saved[1] =~ '^gabl\%(:\f\+\)*$' &&
                    \ g:saved[1] =~ '^tawl\%(:\f\+\)*$' &&
                    \ g:saved[1] =~ '^tabl\%(:\f\+\)*$'
            echoerr 'Invalied content in ' . expand(g:color_toy_config_file)
            return 0
        endif

        let g:color_toy_mode                          = g:saved[0]
        let g:color_toy_gui_vim_color_white_list      = split(g:saved[1], ':')[1:]
        let g:color_toy_gui_vim_color_black_list      = split(g:saved[2], ':')[1:]
        let g:color_toy_term_vim_color_white_list     = split(g:saved[3], ':')[1:]
        let g:color_toy_term_vim_color_black_list     = split(g:saved[4], ':')[1:]
        let g:color_toy_gui_airline_color_white_list  = split(g:saved[5], ':')[1:]
        let g:color_toy_gui_airline_color_black_list  = split(g:saved[6], ':')[1:]
        let g:color_toy_term_airline_color_white_list = split(g:saved[7], ':')[1:]
        let g:color_toy_term_airline_color_black_list = split(g:saved[8], ':')[1:]
    else
        " set default options.
        let g:color_toy_mode = 'white'

        let g:color_toy_gui_vim_color_black_list = []
        let g:color_toy_term_vim_color_black_list = []
        let g:color_toy_gui_vim_color_white_list = g:color_toy_vim_colors_collected
        let g:color_toy_term_vim_color_white_list = g:color_toy_vim_colors_collected

        let g:color_toy_gui_airline_color_black_list = []
        let g:color_toy_term_airline_color_black_list = []
        let g:color_toy_gui_airline_color_white_list = g:color_toy_airline_colors_collected
        let g:color_toy_term_airline_color_white_list = g:color_toy_airline_colors_collected
    endif
endfunction

function! mudox#color_toy_options#Save()
    let l:to_save= []
    call add(l:to_save, 'mode:' . g:color_toy_mode)
    call add(l:to_save, 'gvwl:' . join(g:color_toy_gui_vim_color_white_list     , ':'))
    call add(l:to_save, 'gvbl:' . join(g:color_toy_gui_vim_color_black_list     , ':'))
    call add(l:to_save, 'tvwl:' . join(g:color_toy_term_vim_color_white_list    , ':'))
    call add(l:to_save, 'tvbl:' . join(g:color_toy_term_vim_color_black_list    , ':'))
    call add(l:to_save, 'gawl:' . join(g:color_toy_gui_airline_color_white_list , ':'))
    call add(l:to_save, 'gabl:' . join(g:color_toy_gui_airline_color_black_list , ':'))
    call add(l:to_save, 'tawl:' . join(g:color_toy_term_airline_color_white_list, ':'))
    call add(l:to_save, 'tabl:' . join(g:color_toy_term_airline_color_black_list, ':'))

    call writefile(l:to_save, expand(g:color_toy_config_file))
endfunction
