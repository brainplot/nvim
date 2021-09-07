local lsp = {}

local function on_attach()
	vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
	vim.wo.signcolumn = 'yes'
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
