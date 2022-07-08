" Python
augroup configs_python
    autocmd!
    autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
        \ formatoptions+=croq softtabstop=4
        \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with

    autocmd FileType python,py nnoremap <silent> <Leader>e :call VimuxRunCommand("clear; python3 " . bufname("%"))<CR>
    " autocmd FileType python,py nnoremap <silent> <Leader>e :call VimuxRunCommand("clear; python -m pipenv shell")<CR>

    autocmd FileType python,py nnoremap <silent> <F7> :call VimuxRunCommand("clear; python3 " . bufname("%") . " < input.txt")<CR>
    " autocmd FileType python,py nnoremap <buffer> <F7> :call  
        " \ :sp<CR> :term python3 % < input.txt<CR> :startinsert<CR>
augroup END

" Bash
augroup configs_bash
    autocmd!
    autocmd BufNewFile *.sh :call append(0, '#!/usr/bin/env bash')
augroup END
