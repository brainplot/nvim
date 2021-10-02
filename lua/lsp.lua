local lsp = {}

local function on_attach()
	vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
	vim.wo.signcolumn = 'yes'
	setn('<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>')
	setn('K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
	setn('gD', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
	setn('<C-K>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
	setn('1gD', '<Cmd>lua vim.lsp.buf.type_definition()<CR>')
	setn('gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
	setn('gR', '<Cmd>lua vim.lsp.buf.rename()<CR>')
	setn('g0', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>')
	setn('gW', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
	setn('gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
	setn('gx', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
	seti('<M-Space>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
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
