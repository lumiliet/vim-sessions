
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

function! MapKey(key)
    exe 'nnore <silent> <Leader>ss' . a:key . ' :SessionSave ' . a:key . '<CR>'
    exe 'nnore <silent> <Leader>sr' . a:key . ' :SessionRestore ' . a:key . '<CR>'
endfunction

call MapKey(2)
