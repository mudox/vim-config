#!/usr/bin/env python
# encoding: utf-8

import re
from os import system
from os import path
from glob import glob

# reget patterns compiled

managerPat = re.compile(
  r"^\s*let g:mdx_bundle_manager = '(.*)'\s*$",
  re.MULTILINE
)

titlePat = re.compile(
  r"^\s*let g:mdx_config_title = '(.*)'\s*$",
  re.MULTILINE
)

varPat = re.compile(
  r'g:mdx_bundles_to_register',
  re.MULTILINE
)

assignPat = re.compile(
  r'^\s*let\s+s:bundle_list\s*=\s*s:bundle_list',
  re.MULTILINE
)

mergeConfig = re.compile(
  r'^\s*MergeConfig\s+(\w+)\s*$',
  re.MULTILINE
)

verboseLine = re.compile(
  r'(^\s*\n){2,}',
  re.MULTILINE
)

commentPat = re.compile(
  r'^\s*"[^"]*?$',
  re.MULTILINE
)

# new composed file content
file_template = """\
" vim: filetype=vim foldmethod=marker fileformat=unix

" Set Tile & Bundle Manager {{{{{{1

{title}
{manager}

" }}}}}}1

" Merge Configs {{{{{{1

{merge}

" }}}}}}1

" Bundles in Current Config {{{{{{1

{body}

{add}\

" }}}}}}1\
"""

for bundle in glob(path.expanduser('~/.vim/vimrc.d/configs.d/*')):
  with open(bundle, mode='r', encoding='utf_8') as f:
    content = f.read()

    # compose title if any
    match = titlePat.search(content)
    title = "\n\ncall SetTitle('{}')".format(match.group(1)) if match else ''
    content = titlePat.sub('', content) # remove old line.

    # compose manager if any
    match = managerPat.search(content)
    manager = "\n\ncall SetBundleManager('{}')".format(match.group(1)) if match else ''
    content = managerPat.sub('', content) # remove old line.

    # all 'g:mdx_bundles_to_register' -> 's:bundle_list'.
    content = varPat.sub('s:bundle_list', content)

    # remove all let 's:bundle_list = s:bundle_list'.
    content = assignPat.sub('', content)

    # insert title & manger settting if any
    cotent = title + manager + content

    # compose 'MergeConfigs' command lines.
    merge_configs = ''
    matches = mergeConfig.findall(content)
    if len(matches) != 0:
      merge_configs = 'MergeConfigs\n' + '\n'.join(
        map(lambda m: '\t\\ {}'.format(m), matches)
      )

    # remove old 'MergeConfig' command lines.
    content = mergeConfig.sub('', content)

    # remove all comment lines.
    content = commentPat.sub('', content)

    # compose 'AddBundles' function line.
    add_bundles = '\n\ncall AddBundles(s:bundle_list)'

    content = file_template.format(
      title   = title,
      manager = manager,
      merge   = merge_configs,
      body    = content,
      add     = add_bundles
    )

    # remove redundant empty lines.
    content = verboseLine.sub('\n', content)

    # write into file.
    system('cls')
    #print(bundle.rjust(100, '-'))
    #print(content)
    #print('\n\n')

    #out_path = 'F:\Temps\out\{}'.format(path.expanduser(path.basename(bundle)))
    #with open(out_path, mode='w', encoding='utf-8') as f:
      #f.write(content)

    #input()
