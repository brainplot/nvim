" vim: set foldmethod=marker foldenable:
call plug#begin(stdpath('data') . '/plugged')

Plug 'airblade/vim-rooter'
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lsp'
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': 'cpp' }
Plug 'rakr/vim-one'
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

"{{{ colorscheme

let g:one_allow_italics=1
colorscheme one

"}}}
"{{{ lightline

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

"}}}
"{{{ cpp-enhanced-highlight

let g:cpp_class_decl_highlight = 1
let g:cpp_class_scope_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_posix_standard = 1

"}}}
"{{{ lsp

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

"}}}
"{{{ ncm2

augroup ncm2
    " enable ncm2 for all buffers
    autocmd BufEnter * call ncm2#enable_for_buffer()
augroup end

inoremap <silent> <expr> <TAB> ncm2_ultisnips#expand_or("\<TAB>", 'n')
inoremap <silent> <expr> <CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"

"}}}
"{{{ ultisnips

let g:UltiSnipsExpandTrigger      = "<Plug>(ultisnips_expand)"
let g:UltiSnipsJumpForwardTrigger   = "<tab>"
let g:UltiSnipsJumpBackwardTrigger  = "<s-tab>"
let g:UltiSnipsEditSplit = "context"
let g:UltiSnipsRemoveSelectModeMappings = 0

"}}}
