" cmdhub: Show all tags assigned in my hugo homepage
python << EOF

import pytoml as toml
from glob import glob
from os.path import expanduser
from pprint import pprint
from textwrap import wrap

site_path = expanduser('~/Sites/mudox.github.io-source/')

# collect taxonomies
config_path = site_path + 'config.toml'
with open(config_path) as cfg:
    taxonomies = toml.load(cfg)['taxonomies'].values()


# collect tags
tags = {}
for t in taxonomies:
   tags[t] = set()

fnames = glob(site_path + 'content/**/*.md')

fn = fnames[0]

for fn in fnames:
    cnt = 0
    toml_text = ''
    for l in open(fn):
        if l[:3] == '+++':
            if cnt == 0:
                cnt += 1
            else:
                break
        elif cnt == 1:
            toml_text += l

    front = toml.loads(toml_text)
    for t in tags:
        items = front.get(t, [])
        tags[t].update(items)

for group in tags:
    print group + ':'
    line = ''.join(map(lambda s: '{:15}'.format(s), sorted(tags[group])))
    print '  ' + '\n  '.join(wrap(line, 60))
    print
EOF
