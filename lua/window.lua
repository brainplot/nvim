local window = {}

function window.optimalsplit(window)
	local ww = vim.api.nvim_win_get_width(window)
	local tw = vim.opt.textwidth:get()
	if tw == 0 then
		tw = 80 -- fallback value if tw is unset
	end
	local insufficientwidthvsplit = ww <= tw * 2
	if insufficientwidthvsplit then
		return "split"
	else
		return "vsplit"
	end
end

function window.opensplit(fname)
	vim.cmd(window.optimalsplit(0) .. " " .. vim.fn.fnameescape(fname))
end

function window.open(fname)
	vim.cmd("edit " .. vim.fn.fnameescape(fname))
end

return window
