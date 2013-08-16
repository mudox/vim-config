import vim
from glob import glob


# Search colors/ for *.vim, which are supposed to be color files.
# Then put all color names in vim's variable 's:my_colos'.
colos = [x[:-4] for x in glob('*.vim')]
vim.command('let s:my_colos = []')
for c in colos:
    vim.command("call add(s:my_colos, '{0}')".format(c))
