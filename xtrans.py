#!/usr/bin/env python3

import re
import os
import time
from os import path
from glob import glob
import textwrap as tw

reRepoAddr = re.compile(
    r'''^let s:repo = ['"]{1,2}(?P<repo>[^'"]+)['"]{1,2}\s*$''',
    re.MULTILINE)

reConfig = re.compile(
    r'^function! s:cfg_func\(\)\s*\n(?P<config>.*)^endfunction',
    re.MULTILINE | re.DOTALL)

n = 1
for bundle in glob(path.expanduser('~/.vim/vimrc.d/bundles.d/*')):
    with open(bundle, mode='r', encoding='utf_8') as f:
        content = f.read()

    # extract & compose new repo address line.
    m = reRepoAddr.search(content)
    repo_line = "let s:bundle.site = '{}'\n".format(
        'https://github.com/' + m.groupdict()['repo'] + '.git' if m else '')

    # extract & compose new config function line.
    m = reConfig.search(content)
    config_lines = '\n\nfunction g:bundle.config() dict\n{}\nendfunction'.format(
        m.groupdict()['config'] if m else '')

    with open('/tmp/out/{}'.format(path.basename(bundle)), mode='w', encoding='utf-8') as f:
        f.write('" vim: filetype=vim foldmethod=marker fileformat=unix\n\n')
        f.write("let s:bundle.name = expand('<sfile>:p:t')\n")
        f.write(repo_line)
        f.write(config_lines)

    # os.system('clear')
    # print(n)
    # n = n + 1
    # print('let s:bundle.name = expand(<sfile>:p:t)')
    # print(repo_line)
    # print(config_lines)

    # time.sleep(0.1)
