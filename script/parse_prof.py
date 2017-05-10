#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
from functools import reduce

patternString = r'''
     ^  FUNCTION \s* (.*)
\n \s*  Called \s* (\d+) \s* times
\n \s*  Total  \s* time: \s* ([^ ]*)
\n \s*  Self   \s* time: \s* ([^\n ]*)
\n
'''

pattern = re.compile(patternString, flags=re.M | re.X)

profileText = open('/tmp/mudox/log/vim/vim.prof').read()


def bySelfTime(t):
  _, _, _, time = t
  return float(time)


matches = list(pattern.findall(profileText))
# sort by self time descending
matches.sort(key=bySelfTime, reverse=True)
# ((func names), (counts), (cpu times), (self times))
zipped = zip(*matches)

# max width for each column
nameW, countW, cpuW, selfW = map(lambda t: reduce(max, map(len, t)), zipped)
nameW = max(16, nameW)
countW = max(8, countW)
cpuW = max(12, cpuW)
selfW = max(12, selfW)

headerTemplate = '{:^%d} {:^%d} {:^%d} {:^%d}' % (nameW, countW, cpuW, selfW)
lineTemplate = '{:>%d} {:>%d} {:^%d} {:^%d}' % (nameW, countW, cpuW, selfW)

print(headerTemplate.format('FUNC NAME', 'COUNT', 'CPU', 'SELF ⌄'))
print(
  headerTemplate.format('-' * nameW, '-' * countW, '-' * cpuW, '-' * selfW))
for m in matches:
  print(lineTemplate.format(*m))
