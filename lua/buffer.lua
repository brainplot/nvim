local buffer = {}

function buffer.clearhlsearch()
	vim.cmd('nohlsearch')
	if vim.fn.has('diff') == 1 then
		vim.cmd('diffupdate')
	end
end

return buffer
