local keymap = {}

local noremap = { noremap = true }
local noremapsilent = { noremap = true, silent = true }

local n = 'n'
local v = 'v'

function keymap.setn(lhs, rhs)
	vim.api.nvim_set_keymap(n, lhs, rhs, noremapsilent)
end

function keymap.setv(lhs, rhs)
	vim.api.nvim_set_keymap(v, lhs, rhs, noremapsilent)
end

function keymap.setn_echo(lhs, rhs)
	vim.api.nvim_set_keymap(n, lhs, rhs, noremap)
end

return keymap
