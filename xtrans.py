#!/usr/bin/env python3

import re
#import os
#import time
from os import path
from glob import glob
#import textwrap as tw

reRepoAddr = re.compile(
    r'''^let s:repo = ['"]{1,2}(?P<repo>[^'"]+)['"]{1,2}\s*$''',
    re.MULTILINE)

reConfig = re.compile(
    r'^function! s:cfg_func\(\)\s*\n(?P<config>.*?)^endfunction',
    re.MULTILINE | re.DOTALL)

reNeoDict = re.compile(
    r'^let\s+s:dict\.(?!name)\w+\s+=.*$(?:\n\s*\\.*$)*',
    re.MULTILINE)

reSub = re.compile(r's:dict')

templTargetLines = """\
" vim: filetype=vim foldmethod=marker fileformat=unix

let g:mdx_bundle.name = expand('<sfile>:p:t')

{site}

let g:mdx_bundle.neodict.name = g:mdx_bundle.name
{neodict}

{config}\
"""

for bundle in glob(path.expanduser('~/.vim/vimrc.d/bundles.d/*')):
    with open(bundle, mode='r', encoding='utf_8') as f:
        content = f.read()

    # extract & compose new repo address line.
    m = reRepoAddr.search(content)
    repo_line = "let g:mdx_bundle.site = '{}'\n".format(
        'https://github.com/' + m.groupdict()['repo'] + '.git' if m else '')

    # extract & compose new config function line.
    m = reConfig.search(content)
    config_lines = 'function g:mdx_bundle.config() dict' + \
        '\n{}\nendfunction'.format(m.groupdict()['config'] if m else '')

    # extract & compose new neobundle dict argument lines.
    foundList = reNeoDict.findall(content)
    if foundList:
        neo_dict_lines = '\n'.join(foundList)
        neo_dict_lines = reSub.sub('g:mdx_bundle.neodict', neo_dict_lines)
    else:
        neo_dict_lines = ''

    # generate the final content.
    targetLines = templTargetLines.format(
        site=repo_line, neodict=neo_dict_lines, config=config_lines)

    # os.system('cls')
    #print(' {} '.format(path.basename(bundle)).center(79, '^'))
    # print()
    # print(targetLines)

    #waitting = input()

    # write into file.
    with open('/tmp/out/{}'.format(path.basename(bundle)),
              mode='w', encoding='utf-8') as f:
        f.write(targetLines)
