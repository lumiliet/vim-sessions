
let s:path = expand('<sfile>:h')

function! SessionSave(session)
    exe 'mksession! ' . GetSessionFilename(a:session)
endfunction

function! SessionRestore(session)
    exe 'source ' . GetSessionFilename(a:session)
endfunction

function! GetSessionFilename(session)
    return s:path .'/sessions/' . a:session . '.session'
endfunction

com! -nargs=1 SessionSave :call SessionSave('<args>')
com! -nargs=1 SessionRestore :call SessionRestore('<args>')

function! s:Map(Fun, list)
    if len(a:list) == 0
        return []
    else
        return [a:Fun(a:list[0])] + s:Map(a:Fun, a:list[1:])
    endif
endfunction

function! MapKeys()
    let numbers = range(1,9)
    let letters = s:Map(function('nr2char'), range(char2nr('a'), char2nr('z')))

    call MapList(numbers)
    call MapList(letters)
endfunction

function! MapList(list)
    for i in a:list
        call MapKey(i)
    endfor
endfunction

function! MapKey(key)
    exe 'nnore <silent> <Leader>ss' . a:key . ' :SessionSave ' . a:key . '<CR>'
    exe 'nnore <silent> <Leader>sr' . a:key . ' :SessionRestore ' . a:key . '<CR>'
endfunction

call MapKeys()
