" vim: set foldmethod=marker foldenable:

" General Options {{{

lua << EOF
-- TODO Change " " to "<Space>"
vim.g.mapleader = " "
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.opt.foldmethod = 'syntax'
vim.opt.formatoptions:remove { 'o' }
vim.opt.hidden = true
vim.opt.incsearch = true
vim.opt.list = true
vim.opt.listchars = { tab = '> ', trail = '-', extends = '>', precedes = '<', nbsp = '+' }
vim.opt.backup = false
vim.opt.foldenable = false
vim.opt.showmode = false
vim.opt.wrap = false
vim.opt.writebackup = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 2
vim.opt.shiftwidth = 0
vim.opt.shortmess:append 'c'
vim.opt.sidescrolloff = 4
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.tabstop = 4
vim.opt.title = true
vim.opt.undofile = true
vim.opt.wildignore = { '.hg', '.svn', '.git', '*~', '*.png', '*.jpg', '*.gif', 'Thumbs.db', '*.min.js', '*.swp', '*.exe' }

if vim.fn.has('win32') == 1 then
    vim.opt.path = '.\\**'
else
    vim.opt.path = vim.fn.getcwd() .. '/**'
end

vim.cmd([[
    filetype plugin indent on
    syntax enable
]])

if vim.fn.has('termguicolors') then
    vim.opt.termguicolors = true
end

if vim.fn.executable('rg') then
    vim.opt.grepprg = 'rg --no-heading --vimgrep'
    vim.opt.grepformat = '%f:%l:%c:%m'
end
EOF

" }}} General Options
" Functions and Autogroups {{{

lua << EOF
vim.cmd([[
function! TrimWhitespaces()
    let l:state = winsaveview()
    keeppatterns %s/\_s*\%$//e
    keeppatterns %s/\s\+$//e
    call winrestview(l:state)
endfunction

augroup buffercleanup
    autocmd!
    " Strip out unwanted whitespaces
    autocmd BufWritePre * call TrimWhitespaces()
augroup end

augroup skeleton
    autocmd!
    " Use completion-nvim in every buffer
    " autocmd BufEnter * lua require('completion').on_attach()
    autocmd BufNewFile *.* silent! execute '0r ' . stdpath('config') . '/templates/skeleton.' . expand('<afile>:e')
augroup end
]])
EOF

" }}} Functions and Autogroups
" Key Mappings {{{

lua << EOF
-- Use <C-L> to clear the highlighting of :set hlsearch.
vim.api.nvim_set_keymap('n', '<C-L>', '<Cmd>lua require("buffer").clearhlsearch()<CR><C-L>', {noremap = true, silent = true})

-- Toggle 'wrap' option
vim.api.nvim_set_keymap('n', '<Leader>w', '<Cmd>lua vim.wo.wrap = not vim.wo.wrap<CR>', {noremap = true, silent = true })

-- Open vimrc in a new split, picked based on current terminal size
vim.api.nvim_set_keymap('n', '<Leader>v', '<Cmd>lua require("window").opensplit(os.getenv("MYVIMRC"))<CR>', { noremap = true, silent = true })

-- Open vimrc on top of the current buffer
vim.api.nvim_set_keymap('n', '<Leader>V', '<Cmd>lua require("window").open(os.getenv("MYVIMRC"))<CR>', { noremap = true, silent = true})

-- Switch between open buffers
vim.api.nvim_set_keymap('n', '<Leader>j', '<Cmd>bnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>k', '<Cmd>bprev<CR>', { noremap = true })

-- Sort selected lines
vim.api.nvim_set_keymap('v', '<Leader>s', ':sort<CR>', { noremap = true, silent = true })

-- Toggle between relativenumber and norelativenumber
vim.api.nvim_set_keymap('n', '<Leader>n', '<Cmd>lua vim.wo.relativenumber = not vim.wo.relativenumber<CR>', { noremap = true })

-- Place current file in the system clipboard
vim.api.nvim_set_keymap('n', '<Leader>y', '<Cmd>%y+<CR>', { noremap = true })
EOF

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
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'pprovost/vim-ps1', { 'for': 'ps1' }
Plug 'rakr/vim-one'
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-surround'

" fzf
if executable('fzf')
    Plug 'junegunn/fzf'
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
        let $FZF_DEFAULT_COMMAND = 'fd -tf'
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
