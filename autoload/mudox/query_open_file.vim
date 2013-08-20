" Usage: execute mudox#query_open_file#Main() . " " . <YOUR FILE>

function! mudox#query_open_file#Main()
    let l:promt = "[]Edit," .
                \ " [k]Above, [j]Below, [K]Top, [J]Bttom," .
                \ " [h]left-side, [r]right-side, [H]left-most, [L]right-most," .
                \ " [t]Tabnew: "

    let l:openways = {}
    let l:openways['k'] = 'aboveleft new '
    let l:openways['j'] = 'belowright new '
    let l:openways['K'] = 'topleft new '
    let l:openways['J'] = 'botright new '
    let l:openways['h'] = 'aboveleft vnew '
    let l:openways['l'] = 'belowright vnew '
    let l:openways['H'] = 'topleft vnew '
    let l:openways['L'] = 'botright vnew '
    let l:openways['t'] = 'tabnew '

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
