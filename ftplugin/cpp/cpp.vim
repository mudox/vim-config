" vim: foldmethod=marker

" set number

" Indent
set cindent
set cinoptions=g0 "indent for public:, protected:, private: in C++ file

" Fold
set foldmethod=syntax
" set foldcolumn=4

" [ctags]"{{{
set tags+=~/.ctags/cpp/libstdc++        " C++ Standard Library
" set tags+=~/.ctags/cpp/gl             " OpenGL
" set tags+=~/.ctags/cpp/qt4            " Qt4

" Build tags of your own project with Ctrl-F12
" Recursively travel through the entire tree rooted on current directory.
nnoremap <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"}}}

" [omnicppcomplete]""{{{
let OmniCpp_NamespaceSearch = 2
let OmniCpp_DisplayMode = 1 " always show members 
let OmniCpp_ShowScopeInAbbr = 0
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_DefaultNamespaces = ["std"]
let OmniCpp_MayCompleteScope = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteDot   = 1
let OmniCpp_LocalSearchDecl  = 1

" Automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview
"}}}
