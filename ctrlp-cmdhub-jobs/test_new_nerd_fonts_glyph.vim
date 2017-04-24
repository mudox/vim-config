" cmdhub: Test new nerd font

function s:make_block(title, code_points)

  let lines = [a:title, '']
  let glyph_list = map(a:code_points, 'printf("  %s  %x", nr2char(v:val), v:val)')
  let glyph_line = join(glyph_list, '')
  let glyph_line = substitute(glyph_line, '.\{72}', "&:", 'g')
  call extend(lines, split(glyph_line, ':'))

  return lines + ['']
endfunction

function s:test()
  let ranges = {
        \  'Seti-UI + Custom': range(0xe4f0, 0xe52b),
        \  'Devicons': range(0xe700, 0xe7cf),
        \  'Font Awesome': range(0xeffe, 0xf2e9),
        \  'Font Awesome Extension': range(0xdffd, 0xe0b7),
        \  'Octicons': range(0xf400, 0xf67c),
        \  'Powerline Extra Symbols': range(0xe0a0, 0xe0d7),
        \  'Font Linux': range(0xf300, 0xf317),
        \  'Pomicons': range(0xe000, 0xe00d),
        \  }

  call Qpen('/tmp/nerd-fonts-glyphs.txt')
  set nowrap
  %delete _
  for [title, range] in items(ranges)
    call append(line('$'), s:make_block(title, range))
  endfor
  0delete _
endfunction

call s:test()
delfunction s:make_block
delfunction s:test
