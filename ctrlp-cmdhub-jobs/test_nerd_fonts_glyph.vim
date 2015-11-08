" cmdhub: Test nerd font

function s:make_block(title, code_points)

  let lines = [a:title, '']
  let glyph_list = map(a:code_points, 'printf("  %s  %x", nr2char(v:val), v:val)')
  let glyph_line = join(glyph_list, '')
  let glyph_line = substitute(glyph_line, '.\{72}', "&:", 'g')
  call extend(lines, split(glyph_line, ':'))

  return lines + ['']
endfunction

function s:test()
  let seti_ui_code_points = range(0xe600, 0xe620)
  let devicons_code_points = range(0xe700, 0xe7c5)
  let awesome_code_points = range(0xf000, 0xf23a)
  let powerline_code_points = range(0xe0a0, 0xe0d4)

  call Qpen('/tmp/nerd-fonts-glyphs.txt')
  set nowrap
  %delete _
  call append(line('$'), s:make_block('SETI-UI', seti_ui_code_points))
  call append(line('$'), s:make_block('DEVICONS', devicons_code_points))
  call append(line('$'), s:make_block('AWESOME', awesome_code_points))
  call append(line('$'), s:make_block('POWERLINE', powerline_code_points))
  0delete _
endfunction

call s:test()
delfunction s:make_block
delfunction s:test
