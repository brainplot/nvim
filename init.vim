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

if has('nvim')
    augroup custom_nvim
        " Use completion-nvim in every buffer
        autocmd BufEnter * lua require('completion').on_attach()
        autocmd BufNewFile *.* silent! execute '0r '.stdpath('config').'/templates/skeleton.'.expand("<afile>:e")
    augroup end
endif

" }}} Function and Autogroups
" Key Mappings {{{

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

" Switch between open buffers
nnoremap <silent> <leader>j :bnext<CR>
nnoremap <silent> <leader>k :bprev<CR>

" Sort selected lines
vnoremap <silent> <leader>s :sort<CR>

" Run current file
nnoremap <leader>x :!"%:p"<Enter>

" }}} Key Mappings
" Netrw {{{

let g:netrw_list_hide = '\.git/$,\.hg/$,\.svn/$' " Hide VCS directories
let g:netrw_winsize = 25

" }}} Netrw
" Plugins {{{

if !has('nvim')
    finish
endif

call plug#begin(stdpath('data') . '/plugged')

Plug 'airblade/vim-rooter'
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'hashivim/vim-terraform'
Plug 'itchyny/lightline.vim'
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': 'cpp' }
Plug 'pprovost/vim-ps1', { 'for': 'ps1' }
Plug 'rakr/vim-one'
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-surround'

" fzf
if executable('fzf')
    if has('macunix') || has('win32')
        " The Windows version of fzf doesn't ship with the vim plugin
        Plug 'junegunn/fzf'
    endif
    Plug 'junegunn/fzf.vim'
endif

" Language Server Protocol
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

" Snippet support
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

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
            \   'gitbranch': 'FugitiveHead'
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
" nvim-lsp {{{

lua require('lsp')

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gR    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gx    <cmd>lua vim.lsp.buf.code_action()<CR>

" }}}
" vim-vsnip {{{

" Mapping below is commented out because the Tab key has special handling due to completion-nvim
" See the completion-nvim section
"
" imap <expr> <Tab>   vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
smap <expr> <Tab>   vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" }}}
" completion-nvim {{{

let g:completion_enable_snippet = 'vim-vsnip'
let g:completion_enable_auto_hover = 0
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_matching_smart_case = 1
let g:completion_trigger_on_delete = 1

let g:completion_confirm_key = ''
imap <expr> <Tab>  pumvisible() ? complete_info()["selected"] != "-1" ?
            \ "\<Plug>(completion_confirm_completion)"  :
            \ vsnip#available(1) ? "\<c-e>\<Plug>(vsnip-expand-or-jump)" : "\<c-e>\<Tab>" :
            \ vsnip#available(1) ? "\<Plug>(vsnip-expand-or-jump)" : "\<Tab>"

" }}}
" fzf.vim {{{

if executable('fzf')
    if executable('fd')
        let $FZF_DEFAULT_COMMAND = 'fd -HI -E .svn -E .git -E .hg -E CVS --type f'
    endif

    nnoremap <leader>F :GFiles<CR>
    nnoremap <leader>f :Files<CR>
    nnoremap <leader>b :Buffers<CR>
    nnoremap <leader>r :Rg<space>
endif

" }}}
" vim-vsnip {{{

let g:vsnip_snippet_dir = stdpath('config') . '/snippets'

" }}}
" vim-terraform {{{

let g:terraform_align=1
let g:terraform_fmt_on_save=1

" }}}
" rust.vim {{{

let g:rustfmt_autosave = 1

" }}}
" vim-rooter {{{

let g:rooter_silent_chdir = 1

" }}}
