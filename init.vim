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
set nowritebackup
set number
set path=**
set relativenumber
set scrolloff=2
set shiftwidth=0
set shortmess+=c
set sidescrolloff=4
set signcolumn=yes
set splitright
set tabstop=4
set title
set undofile
set wildignore=.hg,.svn,.git,*~,*.png,*.jpg,*.gif,Thumbs.db,*.min.js,*.swp,*.exe

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
nnoremap <leader>v :exe <SID>optimal_split() . fnameescape($MYVIMRC)<CR>
" Open vimrc on top of the current buffer
nnoremap <leader>V :exe 'edit' . fnameescape($MYVIMRC)<CR>

" }}} Key Mappings
" Netrw {{{

let g:netrw_list_hide = '\.git/$,\.hg/$,\.svn/$' " Hide VCS directories

" }}} Netrw
" Plugins {{{

call plug#begin(stdpath('data') . '/plugged')

Plug 'airblade/vim-rooter'
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lsp'
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': 'cpp' }
Plug 'rakr/vim-one'
Plug 'tmsvg/pear-tree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-git'
Plug 'tpope/vim-surround'

" Completion
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-ultisnips'
Plug 'roxma/nvim-yarp'

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
" nvim-lsp {{{

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

lua << EOF

local nvim_lsp = require'nvim_lsp'
local ncm2 = require'ncm2'

nvim_lsp.rust_analyzer.setup{on_init = ncm2.register_lsp_source}

nvim_lsp.clangd.setup{
    cmd = {
        'clangd',
        '--background-index',
        '--compile-commands-dir=build',
        '--fallback-style=WebKit',
        '--header-insertion=never',
        '--pch-storage=memory',
        '-j=6'
    };
    on_init = ncm2.register_lsp_source
}

EOF

" }}}
" ncm2 {{{

augroup ncm2
    " enable ncm2 for all buffers
    autocmd BufEnter * call ncm2#enable_for_buffer()
augroup end

inoremap <silent> <expr> <TAB> ncm2_ultisnips#expand_or("\<TAB>", 'n')

" }}}
" ultisnips {{{

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsEditSplit = "context"
let g:UltiSnipsRemoveSelectModeMappings = 0

" }}}
" fzf.vim {{{

if executable('fd')
    let $FZF_DEFAULT_COMMAND = 'fd --type f'
endif

nnoremap <leader>F :FZF<CR>
nnoremap <leader>f :GFiles<CR>
nnoremap <leader>r :Rg<space>

" }}}
" pear-tree {{{

let g:pear_tree_map_special_keys = 0

imap <silent> <expr> <CR> pumvisible() ? "\<C-y>\<Plug>(PearTreeExpand)" : "\<Plug>(PearTreeExpand)"
imap <silent> <expr> <ESC> pumvisible() ? "\<C-y>\<Plug>(PearTreeFinishExpansion)" : "\<Plug>(PearTreeFinishExpansion)"
imap <BS> <Plug>(PearTreeBackspace)

" }}}
