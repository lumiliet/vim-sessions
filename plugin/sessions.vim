
autocmd VimLeave * :call s:OnClose()

let s:path = expand('<sfile>:h')
let s:jumpListPosition = 1

com! -nargs=1 SessionSave :call s:SessionSave('<args>', 1)
com! -nargs=1 SessionRestore :call s:SessionRestore('<args>',1)
com! -nargs=0 SessionTravelJumpList :call s:TravelJumpList()
com! -nargs=1 SessionTravelExitHistory :call s:TravelExitHistory('<args>')

function! s:SessionSave(session, addToJumplist)
    if a:session == ""
        return
    endif
    exe "mksession! " . s:GetSessionFilename(a:session)
    if a:addToJumplist
        call s:AddToJumpList(a:session)
    else
        call s:AddToExitHistory(a:session)
    endif
endfunction

function! s:SessionRestore(session, jump)
    if a:session == ""
        return
    endif
    let filename = s:GetSessionFilename(a:session)
    if filereadable(filename)
        call s:DeleteBuffers()
        exe 'source ' . filename
        if a:jump
            call s:AddToJumpList(a:session)
        endif
    endif
endfunction

function! s:TravelExitHistory(position)
    let line = s:GetLineFromFile(s:GetExitHistoryFilename(), a:position)
    call s:SessionRestore(line, 1)
endfunction


function! s:DeleteBuffers()
    let b_all = range(1, bufnr('$'))
    let b_unl = filter(b_all, 'buflisted(v:val)')
    for i in b_unl
        exe i . 'bd!'
    endfor
endfunction

function! s:OnClose()
    call s:SessionSave(strftime("%c"), 0)
endfunction

function! s:TravelJumpList()
    let line = s:GetLineFromFile(s:GetJumpListFilename(), s:jumpListPosition)
    let s:jumpListPosition = s:jumpListPosition + 1
    call s:SessionRestore(line, 0)
endfunction

function! s:GetLineFromFile(fileName, lineNumber)
    if filereadable(a:fileName)
        return readfile(a:fileName, '', -a:lineNumber)[0]
    else
        return ""
    endif
endfunction

function! s:GetJumpListFilename()
    return s:path .'/../.jumplist'
endfunction

function! s:GetExitHistoryFilename()
    return s:path .'/../.exit-history'
endfunction

function! s:WriteLineToJumpList(session)
    let jumplist = s:GetJumpListFilename()
    call writefile([a:session], jumplist, "a")
endfunction

function! s:AddToExitHistory(session)
    let exitHistoryFile = s:GetExitHistoryFilename()
    call writefile([a:session], exitHistoryFile, "a")
endfunction

function! s:AddToJumpList(session)
    let s:jumpListPosition = 1
    let line = s:GetLineFromFile(s:GetJumpListFilename(), s:jumpListPosition)
    if line != a:session
        call s:WriteLineToJumpList(a:session)
    endif
endfunction

function! s:GetSessionFilename(session)
    return s:path .'/../sessions/' . substitute(a:session, '\s', '-', 'g') . '.session'
endfunction

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

    call s:MapList(letters, 0)
    call s:MapList(numbers, 1)

    nnore <silent> <Leader>so :SessionTravelJumpList <CR>
endfunction

function! s:MapList(list, history)
    for i in a:list
        if a:history
            call s:MapHistoryKey(i)
        else
            call s:MapKey(i)
        endif
    endfor
endfunction

function! s:MapHistoryKey(key)
    exe 'nnore <silent> <Leader>sr' . a:key . ' :SessionTravelExitHistory ' . a:key . '<CR>'
endfunction

function! s:MapKey(key)
    exe 'nnore <silent> <Leader>ss' . a:key . ' :SessionSave ' . a:key . '<CR>'
    exe 'nnore <silent> <Leader>sr' . a:key . ' :SessionRestore ' . a:key . '<CR>'
endfunction

call s:MapKeys()
