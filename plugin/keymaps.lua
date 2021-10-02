local noremap = { noremap = true }
local noremapsilent = { noremap = true, silent = true }

local n = 'n'
local v = 'v'
local i = 'i'

function setn(lhs, rhs)
	vim.api.nvim_set_keymap(n, lhs, rhs, noremapsilent)
end

function setv(lhs, rhs)
	vim.api.nvim_set_keymap(v, lhs, rhs, noremapsilent)
end

function seti(lhs, rhs)
	vim.api.nvim_set_keymap(i, lhs, rhs, noremapsilent)
end

function setn_echo(lhs, rhs)
	vim.api.nvim_set_keymap(n, lhs, rhs, noremap)
end

-- Use <C-L> to clear the highlighting of :set hlsearch.
setn('<C-L>', '<Cmd>lua require("buffer").clearhlsearch()<CR><C-L>')

-- Toggle 'wrap' option
setn('<Leader>w', '<Cmd>lua vim.wo.wrap = not vim.wo.wrap<CR>')

-- Open vimrc in a new split, picked based on current terminal size
setn('<Leader>v', '<Cmd>lua require("window").opensplit(vim.env.MYVIMRC)<CR>')

-- Open vimrc on top of the current buffer
setn('<Leader>V', '<Cmd>lua require("window").open(vim.env.MYVIMRC)<CR>')

-- Switch between open buffers
setn('<Leader>j', '<Cmd>bnext<CR>')
setn('<Leader>k', '<Cmd>bprev<CR>')

-- Sort selected lines
setv('<Leader>s', ':sort<CR>')

-- Toggle between relativenumber and norelativenumber
setn('<Leader>n', '<Cmd>lua vim.wo.relativenumber = not vim.wo.relativenumber<CR>')

-- Place current file in the system clipboard
setn_echo('<Leader>y', '<Cmd>%y+<CR>')
