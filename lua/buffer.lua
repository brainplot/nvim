local buffer = {}

function buffer.clearhlsearch()
	vim.cmd('nohlsearch')
	if vim.fn.has('diff') == 1 then
		vim.cmd('diffupdate')
	end
end

function buffer.trim()
	local view = vim.fn.winsaveview()
	vim.cmd [[
		keeppatterns %s/\_s*\%$//e
		keeppatterns %s/\s\+$//e
	]]
	vim.fn.winrestview(view)
end

return buffer
