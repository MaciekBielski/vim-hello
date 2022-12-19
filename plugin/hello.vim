if exists('g:hello_loaded')
    finish
endif
let g:hello_loaded = 1

let s:save_cpo = &cpo
set cpo&vim          " reset to defaults

" echohl WarningMsg
" echom 'HeLLo'
" echohl None

" command! RunHello lua require('hello').go()
"
" test with: nvim -c 'lua hello.open_float_window()'
lua hello = require('hello')

let &cpo = s:save_cpo
unlet s:save_cpo


" func! s:opt(name, default)
"     let val = get(g:, a:name, a:default)
"     let cmd = 'let g:' . a:name . '= l:val'
"     execute cmd
" endfunc

" call s:opt('ncm2#auto_popup', 1)

" inoremap <silent> <Plug>(ncm2_auto_trigger)      <c-r>=ncm2#auto_trigger()<cr>
" inoremap <silent> <expr> <Plug>(ncm2_c_e) (pumvisible() ? "\<c-e>" : '')

" func! ncm2#insert_mode_only_key(key)
"     exe 'map' a:key '<nop>'
"     exe 'cmap' a:key '<nop>'
"     if exists(':tmap')
"         exe 'tmap' a:key '<nop>'
"     endif
" endfunc
" call ncm2#insert_mode_only_key('<Plug>(ncm2_skip_auto_trigger)')

" func! s:dbg(str)
"     echom a:str . ' ' . json_encode(ncm2#context_tick())
" endfunc
