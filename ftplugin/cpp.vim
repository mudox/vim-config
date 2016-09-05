" vim: foldmethod=marker

" Indent
setlocal cindent
setlocal cinoptions=g0 "indent for public:, protected:, private: in C++ file

" Fold
setlocal foldmethod=syntax

" [ctags]"{{{1
setlocal tags+=~/.ctags/cpp/libstdc++        " C++ Standard Library
" setlocal tags+=~/.ctags/cpp/gl             " OpenGL
" setlocal tags+=~/.ctags/cpp/qt4            " Qt4

" Build tags of your own project with Ctrl-F12
" Recursively travel through the entire tree rooted on current directory.
nnoremap <buffer> \tag :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"}}}1
