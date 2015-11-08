" cmdhub: Update 'Date' front matter for Hugo content file

1,10s/^date\s*=\s*"\zs\d\{4}-\d\d-\d\dT\d\d:\d\d:\d\d+08:00\ze"/\=strftime("%FT%T+08:00")/c
