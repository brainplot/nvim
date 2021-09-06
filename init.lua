-- vim: set foldmethod=marker foldenable:

-- General Options {{{

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
    " Use completion-nvim in every buffer
    " autocmd BufEnter * lua require('completion').on_attach()
    autocmd BufNewFile *.* silent! execute '0r ' . stdpath('config') . '/templates/skeleton.' . expand('<afile>:e')
augroup end
]])

-- }}} Functions and Autogroups
-- Key Mappings {{{

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

-- }}} Key Mappings
-- Netrw {{{

vim.g.netrw_list_hide = '\\.git/$,\\.hg/$,\\.svn/$'
vim.g.netrw_winsize = 25

-- }}} Netrw
-- Plugins {{{

require('plugins')

-- }}} Plugins
