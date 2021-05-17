local nvim_lsp = require('lspconfig')

function init_lsp_buffer()
	vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
	vim.wo.signcolumn = 'yes'
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.gopls.setup {
	capabilities = capabilities,
	cmd = {'gopls', 'serve'},
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
	on_attach = init_lsp_buffer
}

nvim_lsp.rust_analyzer.setup {
	capabilities = capabilities,
	on_attach = init_lsp_buffer,
	settings = {
		['rust-analyzer'] = {
			assist = {
				importMergeBehavior = 'last',
				importPrefix = 'by_self',
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

nvim_lsp.terraformls.setup {
	capabilities = capabilities,
	on_attach = init_lsp_buffer
}
