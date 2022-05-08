local lsp = {}

local function on_attach()
	vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
	vim.wo.signcolumn = 'yes'
	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	vim.api.nvim_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	vim.api.nvim_set_keymap('n', '<C-K>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	vim.api.nvim_set_keymap('i', '<C-K>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	vim.api.nvim_set_keymap('n', 'gR', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
	vim.api.nvim_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
	vim.api.nvim_set_keymap('n', 'gs', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
	vim.api.nvim_set_keymap('n', 'gS', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
	vim.api.nvim_set_keymap('n', 'gx', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	vim.api.nvim_set_keymap('n', 'gD', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
end

function lsp.setup(userConfig)
	local lspconfig = require('lspconfig')

	lspconfig.gopls.setup {
		capabilities = userConfig.capabilities,
		cmd = {'gopls', 'serve'},
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
				directoryFilters = {
					'-node_modules',
					'-dist',
				},
				templateExtensions = {
					'tmpl',
				},
			},
		},
		on_attach = on_attach
	}

	lspconfig.rust_analyzer.setup {
		capabilities = userConfig.capabilities,
		on_attach = on_attach,
		settings = {
			['rust-analyzer'] = {
				assist = {
					importMergeBehavior = 'last',
				},
				cargo = {
					loadOutDirsFromCheck = true,
				},
				lens = {
					debug = false,
					enable = false,
				}
			}
		}
	}

	lspconfig.terraformls.setup {
		capabilities = userConfig.capabilities,
		on_attach = on_attach
	}
end

return lsp
