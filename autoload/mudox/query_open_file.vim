" Usage: execute mudox#query_open_file#Main() . " " . <YOUR FILE>

function! mudox#query_open_file#Main()
    let l:promt = "[]Edit," .
                \ " [k]Above, [j]Below, [K]Top, [J]Bottom," .
                \ " [h]Left-Side, [r]Right-Side, [H]Left-Most, [L]Right-Most," .
                \ " [t]Tabnew: "

    let l:openways = {}

    " WARNING: keep the trailing space.
    let l:openways['k'] = 'aboveleft new' . "\x20"
    let l:openways['j'] = 'belowright new' . "\x20"
    let l:openways['K'] = 'topleft new' . "\x20"
    let l:openways['J'] = 'botright new' . "\x20"
    let l:openways['h'] = 'aboveleft vnew' . "\x20"
    let l:openways['l'] = 'belowright vnew' . "\x20"
    let l:openways['H'] = 'topleft vnew' . "\x20"
    let l:openways['L'] = 'botright vnew' . "\x20"
    let l:openways['t'] = 'tabnew' . "\x20"

    while 1
        let l:open = input(l:promt)
        let l:open = substitute(l:open, '\s\+', '', 'g') " strip spaces in l:open

        if l:open == ''
            return 'drop '
        elseif l:open =~ '^[jkJKhlHLt]$'
            return l:openways[l:open]
        else
            call EchoError("\nInvalid input, need [k,j,K,J,h,l,H,L,t or empty]")
        endif
    endw
endfunction
