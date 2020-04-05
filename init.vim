" vi: set ts=4 sw=4 expandtab:

set runtimepath^=/usr/share/vim/vimfiles/

call plug#begin(stdpath('data') . '/plugged')
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
call plug#end()

if (empty($TMUX))
    if (has("termguicolors"))
        set termguicolors
    endif
endif

let g:one_allow_italics=1
colorscheme one
set background=dark

let g:lightline = {
            \ 'colorscheme': 'one',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'gitbranch': 'gitbranch#name'
            \ },
            \ }

function! s:clean_up_whitespaces()
    let cursorpos = getcurpos()
    silent! %s/\_s*\%$//
    silent! %s/\s\+$//
    call setpos('.', cursorpos)
endfunction

" Strip out unwanted whitespaces
autocmd BufWritePre * call s:clean_up_whitespaces()

" Keybindings to quickly run the buffer being edited
autocmd FileType python nnoremap <buffer> <F8> :w<CR>:exec '!python' shellescape(@%, 1)<CR>

" Custom key mappings
vnoremap <F9> :sort<CR>

set list
set noshowmode
set number
set relativenumber
set shiftwidth=0
set tabstop=4

runtime! coc.vim
