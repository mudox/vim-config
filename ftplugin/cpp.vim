" vim: foldmethod=marker

" set number

" Indent
set cindent
set cinoptions=g0 "indent for public:, protected:, private: in C++ file

" Fold
set foldmethod=syntax

" [ctags]"{{{
set tags+=~/.ctags/cpp/libstdc++        " C++ Standard Library
" set tags+=~/.ctags/cpp/gl             " OpenGL
" set tags+=~/.ctags/cpp/qt4            " Qt4

" Build tags of your own project with Ctrl-F12
" Recursively travel through the entire tree rooted on current directory.
nnoremap <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"}}}
