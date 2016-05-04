com! -nargs=1 SessionSave :call s:SessionSave('<args>')
com! -nargs=1 SessionRestore :call s:SessionRestore('<args>',1)
com! -nargs=0 SessionTravel :call s:TravelJumpList()

autocmd VimLeave * :call s:OnClose()

let s:path = expand('<sfile>:h')
let s:jumpListPosition = 1

function! s:SessionSave(session)
    if a:session == ""
        return
    endif
    exe "mksession! " . s:GetSessionFilename(a:session)
    call s:AddToJumpList(a:session)
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

function! s:DeleteBuffers()
    let b_all = range(1, bufnr('$'))
    let b_unl = filter(b_all, 'buflisted(v:val)')
    for i in b_unl
        exe i . 'bd'
    endfor
endfunction

call s:DeleteBuffers()

function! s:OnClose()
    call s:SessionSave(strftime("%c"))
endfunction

function! s:TravelJumpList()
    let line = s:GetLineFromJumpList(s:jumpListPosition)
    let s:jumpListPosition = s:jumpListPosition + 1
    call s:SessionRestore(line, 0)
endfunction

function! s:GetLineFromJumpList(lineNumber)
    let jumplist = s:GetJumpListFilename()
    if filereadable(jumplist)
        return readfile(jumplist, '', -a:lineNumber)[0]
    else
        return ""
    endif
endfunction

function! s:GetJumpListFilename()
    return s:path .'/../.jumplist'
endfunction

function! s:WriteLineToJumpList(session)
    let jumplist = s:GetJumpListFilename()
    call writefile([a:session], jumplist, "a")
endfunction

function! s:AddToJumpList(session)
    let s:jumpListPosition = 1
    let line = s:GetLineFromJumpList(1)
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
