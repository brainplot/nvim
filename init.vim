" vi: set ts=4 sw=4 expandtab:

call plug#begin(stdpath('data') . '/plugged')
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-sensible'
call plug#end()

if (empty($TMUX))
    if (has("nvim"))
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
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

" Remove trailing whitespaces
autocmd BufWritePre * %s/\s\+$//e

set list
set noshowmode
set number
set relativenumber
set shiftwidth=0
set tabstop=4
