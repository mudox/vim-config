import os, vim
from glob import glob
from os import path

os.chdir(path.abspath('../../../colors/'))
colos = [ x[:-4] for x in glob('*.vim') ]

if colos:
    vim.command('let s:my_colos = []')
    for c in colos:
        vim.command("let s:my_colos = add(s:my_colos, '{0}')".format(c))
else:
    vim.command('echohl ErrorMsg | echo "No colorscheme file found" | echohl None')
