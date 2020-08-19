" vim: set foldmethod=marker foldenable:

" General Options {{{

let mapleader = "\<Space>"
set completeopt=menuone,noinsert,noselect
set foldmethod=syntax
set formatoptions-=o
set hidden
set incsearch
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set nobackup
set nofoldenable
set noshowmode
set nowrap
set nowritebackup
set number
set relativenumber
set scrolloff=2
set shiftwidth=0
set shortmess+=c
set sidescrolloff=4
set splitright
set tabstop=4
set title
set undofile
set wildignore=.hg,.svn,.git,*~,*.png,*.jpg,*.gif,Thumbs.db,*.min.js,*.swp,*.exe

if has('win32')
    set path=.\**
else
    set path=$PWD/**
endif

filetype plugin indent on
syntax enable
colorscheme darkblue " Set default colorscheme in case of no plugins

if has('termguicolors')
    set termguicolors
endif

if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

" }}} General Options
" Function and Autogroups {{{

function! s:clean_up_whitespaces()
    let cursorpos = getcurpos()
    silent! %s/\_s*\%$//
    silent! %s/\s\+$//
    call setpos('.', cursorpos)
endfunction

function! s:optimal_split()
    return winwidth(0) <= 2 * (&tw ? &tw : 80) ? 'split' : 'vsplit'
endfunction

augroup custom
    autocmd!
    " Strip out unwanted whitespaces
    autocmd BufWritePre * call <SID>clean_up_whitespaces()
    " Don't automatically insert comments
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
augroup end

" }}} Function and Autogroups
" Key Mappings {{{

vnoremap <silent> <F9> :sort<CR>

" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Quickly insert an empty new line without entering insert mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" Toggle 'wrap' option
nnoremap <silent> <Leader>w :set wrap!<CR>

" Open vimrc in a new split, picked based on current terminal size
nnoremap <silent> <leader>v :exe <SID>optimal_split() . ' ' . fnameescape($MYVIMRC)<CR>
" Open vimrc on top of the current buffer
nnoremap <silent> <leader>V :exe 'edit ' . fnameescape($MYVIMRC)<CR>

" }}} Key Mappings
" Netrw {{{

let g:netrw_list_hide = '\.git/$,\.hg/$,\.svn/$' " Hide VCS directories

" }}} Netrw
" Plugins {{{

if !has('nvim')
    finish
endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'airblade/vim-rooter'
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': 'cpp' }
Plug 'pprovost/vim-ps1', { 'for': 'ps1' }
Plug 'rakr/vim-one'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-git'
Plug 'tpope/vim-surround'

" fzf
if executable('fzf')
    if has('win32')
        " The Windows version of fzf doesn't ship with the vim plugin
        Plug 'junegunn/fzf'
    endif
    Plug 'junegunn/fzf.vim'
endif

" Language Server Protocol
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" Completion
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

" }}} Plugins
" vim-one {{{

let g:one_allow_italics=1
colorscheme one

" }}}
" lightline {{{

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

" }}}
" cpp-enhanced-highlight {{{

let g:cpp_class_decl_highlight = 1
let g:cpp_class_scope_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_posix_standard = 1

" }}}
" vim-lsp {{{

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" }}}
" ultisnips {{{

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsEditSplit = "context"
let g:UltiSnipsRemoveSelectModeMappings = 0

" }}}
" asyncomplete {{{

" Ultisnips
call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
            \ 'name': 'ultisnips',
            \ 'whitelist': ['*'],
            \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
            \ }))

" }}}
" fzf.vim {{{

if executable('fzf')
    if executable('fd')
        let $FZF_DEFAULT_COMMAND = 'fd --type f'
    endif

    nnoremap <leader>F :FZF<CR>
    nnoremap <leader>f :GFiles<CR>
    nnoremap <leader>r :Rg<space>
endif

" }}}
