" vim visput: fix visual put
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

" the currently active v:register
let s:register = '"'

function! s:VisualPut(type, ...) abort
  let l:height = line("']") - line("'[") + 1
  let l:width = col("']") - col("'[") + 1

  let l:regval = getreg(s:register, 1, 1)
  let l:regtype = getregtype(s:register)

  if a:type == 'block' && l:regtype[0] ==# "\<c-v>"
    let l:regheight = len(l:regval)
    let l:regwidth = l:regtype[1:]

    if l:regheight != l:height || l:regwidth != l:width
      let l:ans = input('visput: block dimension mismatch; continue? (y/N) ')
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

function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction

function! s:setup()
  let s:register = v:register
  let &opfunc = "\<SNR>" . s:SID() . '_VisualPut'
  return ''
endfunction

xmap <silent> <plug>(visput-p) :<c-u>call <sid>setup()<cr>g@<sid>(visual)

xmap <silent> p <plug>(visput-p)
xmap <silent> P <plug>(visput-p)
