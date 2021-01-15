
" the currently active v:register
let s:register = '"'
let g:visput_stuff_register = ''

function! VisualPut(type, ...)
  let l:height = line("']") - line("'[") + 1
  let l:width = col("']") - col("'[") + 1

  let l:regval = getreg(s:register, 1, 1)
  let l:regtype = getregtype(s:register)

  if a:type == 'block' && l:regtype[0] ==# "\<c-v>"
    let l:regheight = len(l:regval)
    let l:regwidth = l:regtype[1:]

    if l:regheight != l:height || l:regwidth != l:width
      let l:ans = input('block dimension mismatch; continue? (y/N) ')
      if l:ans isnot? 'y'
        return
      endif
    endif
  endif

  execute 'normal! gv"'.s:register.'p'

  if s:register ==# '"'
    call setreg(s:register, l:regval, l:regtype)
  endif
endfunction

command! VisPutMotion normal! 1v

onoremap <silent> <sid>(visual) v:<c-u>VisPutMotion<cr>

function! s:setup()
  let s:register = v:register
  set opfunc=VisualPut
  return ''
endfunction

xmap <silent> p :<c-u>call <sid>setup()<cr>g@<sid>(visual)
xmap <silent> P p

