from glob import glob
from os import path
import textwrap

flag = False
for vimDir in ['.vim', 'vimfiles']:
    if path.exists(path.expanduser('~/%s' % vimDir)):
        configs_dir = path.expanduser('~/%s/vimrc.d/configs.d' % vimDir)
        cur_config = path.expanduser('~/%s/vimrc.d/cur_config' % vimDir)
        if path.exists(configs_dir):
            flag = True

if not flag:
    print '* .vim/vimfiles path detection failed *'
    exit()

config_paths = glob(configs_dir + '/*')
config_names = [path.basename(x) for x in config_paths]
config_names = filter(lambda n: not n.startswith('sub_cfg_'), config_names)
config_names = filter(lambda n: not n.startswith('x_'), config_names)

menu_dict = {idx: name for idx, name in enumerate(sorted(config_names))}

print '-------- Vim Configuration Available --------'
for idx, name in menu_dict.items():
    print '[{0}] - {1}'.format(idx, name)

print '---------------------------------------------'

try:
    while 1:
        config_idx = input('Select your configuation: ')
        if config_idx in menu_dict:
            break
        else:
            print('Oops, invalid input!')
            # TODO: beautify menu interface if got a invalid input.
except:
    pass
else:
    so_line = textwrap.dedent('''\
    let g:mdx_config_name = '{0}'
    execute 'source ' . g:rc_root . '/vimrc.d/configs.d/{0}'
    ''')

    with open(cur_config, 'w') as cc:
        cc.write(so_line.format(menu_dict[config_idx]))

    print 'Switched to >> %s << !' % menu_dict[config_idx]
