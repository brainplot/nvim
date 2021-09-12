-- vim: set foldmethod=marker foldenable:

-- General Options {{{

vim.g.mapleader = " "
vim.opt.backup = false
vim.opt.colorcolumn = '+1'
vim.opt.completeopt = { 'menuone', 'noinsert' }
vim.opt.foldenable = false
vim.opt.foldmethod = 'syntax'
vim.opt.formatoptions:remove { 'o' }
vim.opt.hidden = true
vim.opt.incsearch = true
vim.opt.list = true
vim.opt.listchars = { tab = '> ', trail = '-', extends = '>', precedes = '<', nbsp = '+' }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 2
vim.opt.shiftwidth = 0
vim.opt.shortmess:append 'c'
vim.opt.showmode = false
vim.opt.sidescrolloff = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.textwidth = 100
vim.opt.title = true
vim.opt.undofile = true
vim.opt.wildignore = { '.hg', '.svn', '.git', '*~', '*.png', '*.jpg', '*.gif', 'Thumbs.db', '*.min.js', '*.swp', '*.exe' }
vim.opt.wrap = false
vim.opt.writebackup = false

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

-- }}} General Options
-- Functions and Autogroups {{{

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
    autocmd BufNewFile *.* silent! execute '0r ' . stdpath('config') . '/templates/skeleton.' . expand('<afile>:e')
augroup end
]])

-- }}} Functions and Autogroups
-- Key Mappings {{{

local keymap = require('keymap')

-- Use <C-L> to clear the highlighting of :set hlsearch.
keymap.setn('<C-L>', '<Cmd>lua require("buffer").clearhlsearch()<CR><C-L>')

-- Toggle 'wrap' option
keymap.setn('<Leader>w', '<Cmd>lua vim.wo.wrap = not vim.wo.wrap<CR>')

-- Open vimrc in a new split, picked based on current terminal size
keymap.setn('<Leader>v', '<Cmd>lua require("window").opensplit(vim.env.MYVIMRC)<CR>')

-- Open vimrc on top of the current buffer
keymap.setn('<Leader>V', '<Cmd>lua require("window").open(vim.env.MYVIMRC)<CR>')

-- Switch between open buffers
keymap.setn('<Leader>j', '<Cmd>bnext<CR>')
keymap.setn('<Leader>k', '<Cmd>bprev<CR>')

-- Sort selected lines
keymap.setv('<Leader>s', ':sort<CR>')

-- Toggle between relativenumber and norelativenumber
keymap.setn('<Leader>n', '<Cmd>lua vim.wo.relativenumber = not vim.wo.relativenumber<CR>')

-- Place current file in the system clipboard
keymap.setn_echo('<Leader>y', '<Cmd>%y+<CR>')

-- }}} Key Mappings
-- Netrw {{{

vim.g.netrw_list_hide = '\\.git/$,\\.hg/$,\\.svn/$'
vim.g.netrw_winsize = 25

-- }}} Netrw
-- Plugins {{{

require('plugins')

-- }}} Plugins
