vim.wo.colorcolumn = '50,72'

if string.len(vim.fn.getline(1)) == 0 then
	vim.fn.setpos('.', { 0, 1, 1, 0 })
end
