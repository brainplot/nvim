" vi: set ts=4 sw=4 expandtab:

set runtimepath^=/usr/share/vim/vimfiles/

runtime! plugins.vim

function! s:clean_up_whitespaces()
    let cursorpos = getcurpos()
    silent! %s/\_s*\%$//
    silent! %s/\s\+$//
    call setpos('.', cursorpos)
endfunction

augroup custom
    autocmd!
    " Strip out unwanted whitespaces
    autocmd BufWritePre * call s:clean_up_whitespaces()
    " Keybindings to quickly run the buffer being edited
    autocmd FileType python nnoremap <buffer> <F8> :w<CR>:exec '!python' shellescape(@%, 1)<CR>
augroup end

" Custom key mappings
vnoremap <F9> :sort<CR>

set list
set noshowmode
set number
set relativenumber
set shiftwidth=0
set splitright
set tabstop=4

if (empty($TMUX))
    if (has("termguicolors"))
        set termguicolors
    endif
endif
