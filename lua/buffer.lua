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

function buffer.writeskeleton()
	local configdir = vim.fn.stdpath('config')
	local extension = vim.fn.expand('%:e')
	local skeletonfile = configdir .. '/templates/skeleton.' .. extension
	if vim.fn.filereadable(skeletonfile) == 1 then
		vim.cmd('read ++edit ' .. skeletonfile)
		vim.fn.deletebufline(vim.fn.bufname(), 1)
		vim.bo.modified = false
	end
end

return buffer
