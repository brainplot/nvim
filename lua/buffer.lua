local buffer = {}

function buffer.trim()
	local view = vim.fn.winsaveview()
	vim.cmd [[
		keeppatterns keepjumps %s/\_s*\%$//e
		keeppatterns keepjumps %s#\($\n\s*\)\+\%$##e
	]]
	vim.fn.winrestview(view)
end

function buffer.writeskeleton()
	local configdir = vim.fn.stdpath('config')
	local extension = vim.fn.expand('%:e')
	local skeletonfile = vim.fn.fnameescape(configdir .. '/templates/skeleton.' .. extension)
	if vim.fn.filereadable(skeletonfile) == 1 then
		vim.cmd('read ++edit ' .. skeletonfile)
		vim.fn.deletebufline(vim.fn.bufname(), 1)
		vim.bo.modified = false
	end
end

return buffer
