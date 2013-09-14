import os, glob

configs_dir = os.path.expanduser('~/.vim/vimrc.d/configs.d')
cur_config = os.path.expanduser('~/.vim/vimrc.d/cur_config')

# on Windows assuming a 'junction' named '.vim' is created to link to _vimfiles
# TODO: fix it to be portable with out extra requirements.
config_paths = glob.glob(os.path.expanduser('~/.vim/vimrc.d/configs.d/*'))
config_names = [ os.path.basename(x) for x in config_paths ]
menu_dict = { idx : name for idx, name in  enumerate(sorted(config_names)) }

print '-------- Vim Configuration Available --------'
for idx, name in menu_dict.items():
    print '[{0}] - {1}'.format(idx, name)
print '---------------------------------------------'

while 1:
    config_idx = input('Select your configuation: ')
    if config_idx in menu_dict:
        break
    # TODO: beautify menu interface if got a invalid input.

so_line = "execute 'source ' . g:rc_root . '/vimrc.d/configs.d/{0}'"

with open(cur_config, 'w') as cc:
    cc.write(so_line.format(menu_dict[config_idx]))

print 'Switched to >> %s << !' % menu_dict[config_idx]
