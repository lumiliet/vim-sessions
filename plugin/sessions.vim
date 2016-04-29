
let s:path = expand('<sfile>:h')

let s:jumpListPosition = 1

function! s:GetLineFromJumpList(lineNumber)
    let jumplist = s:GetSessionFilename('jumplist')
    return readfile(jumplist, '', -a:lineNumber)[0]
endfunction

function! s:TravelJumpList()
    let line = s:GetLineFromJumpList(s:jumpListPosition)
    let s:jumpListPosition = s:jumpListPosition + 1
    call s:SessionRestore(line, 0)
endfunction

com! -nargs=0 SessionTravel :call s:TravelJumpList()

function! s:WriteLineToJumpList(session)
    let jumplist = s:GetSessionFilename('jumplist')
    call writefile([a:session], jumplist, "a")
endfunction

function! s:AddToJumpList(session)
    let s:jumpListPosition = 1
    let line = s:GetLineFromJumpList(1)
    if line != a:session
        call s:WriteLineToJumpList(a:session)
    endif
endfunction

function! s:SessionSave(session)
    exe 'mksession! ' . s:GetSessionFilename(a:session)
    call s:AddToJumpList(a:session)
endfunction

function! s:SessionRestore(session, jump)
    let filename = s:GetSessionFilename(a:session)
    if filereadable(filename)
        exe 'source ' . filename
        if a:jump
            call s:AddToJumpList(a:session)
        endif
    endif
endfunction

function! s:GetSessionFilename(session)
    return s:path .'/../sessions/' . a:session . '.session'
endfunction

com! -nargs=1 SessionSave :call s:SessionSave('<args>')
com! -nargs=1 SessionRestore :call s:SessionRestore('<args>',1)

function! s:Map(Fun, list)
    if len(a:list) == 0
        return []
    else
        return [a:Fun(a:list[0])] + s:Map(a:Fun, a:list[1:])
    endif
endfunction

function! s:MapKeys()
    let numbers = range(1,9)
    let letters = s:Map(function('nr2char'), range(char2nr('a'), char2nr('z')))

    call s:MapList(numbers)
    call s:MapList(letters)
endfunction

function! s:MapList(list)
    for i in a:list
        call s:MapKey(i)
    endfor
endfunction

function! s:MapKey(key)
    exe 'nnore <silent> <Leader>ss' . a:key . ' :SessionSave ' . a:key . '<CR>'
    exe 'nnore <silent> <Leader>sr' . a:key . ' :SessionRestore ' . a:key . '<CR>'
endfunction

exe 'nnore <silent> <Leader>so :SessionTravel <CR>'

call s:MapKeys()
