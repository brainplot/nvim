" vi: set ts=4 sw=4 expandtab:

call plug#begin(stdpath('data') . '/plugged')

Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rakr/vim-one'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

call plug#end()

runtime! coc.vim
runtime! lightline.vim
runtime! theme.vim
runtime! snippets.vim
