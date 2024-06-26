local l = {}

function l.setup(config)
	local lspconfig = require("lspconfig")
	local capabilities = config.capabilities

	if vim.fn.executable("gopls") == 1 then
		lspconfig.gopls.setup({
			capabilities = capabilities,
			cmd = { "gopls", "serve" },
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					directoryFilters = {
						"-node_modules",
						"-dist",
					},
					templateExtensions = {
						"tmpl",
					},
				},
			},
		})
	end

	if vim.fn.executable("rust-analyzer") == 1 then
		lspconfig.rust_analyzer.setup({
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					assist = {
						importMergeBehavior = "last",
					},
					cargo = {
						loadOutDirsFromCheck = true,
					},
					lens = {
						debug = false,
						enable = false,
					},
				},
			},
		})
	end

	if vim.fn.executable("terraform-ls") == 1 then
		lspconfig.terraformls.setup({
			capabilities = capabilities,
		})
	end

	if vim.fn.executable("pylsp") == 1 then
		lspconfig.pylsp.setup({
			capabilities = capabilities,
		})
	end

	if vim.fn.executable("quick-lint-js") == 1 then
		lspconfig.quick_lint_js.setup({
			capabilities = capabilities,
		})
	end

	if vim.fn.executable("emmet-language-server") == 1 then
		lspconfig.emmet_language_server.setup({})
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
		callback = function(ev)
			-- Enable completion triggered by <c-x><c-o>
			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

			-- Show sign column
			vim.wo.signcolumn = "yes"

			-- Buffer local mappings
			local opts = { buffer = ev.buf }
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<leader>h", vim.lsp.buf.signature_help, opts)
			vim.keymap.set({ "n", "v" }, "<leader>x", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)

			local lspbuffercleanupid = vim.api.nvim_create_augroup("LspBufferCleanup", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = lspbuffercleanupid,
				desc = "Remove unwanted whitespaces from LSP buffer",
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end,
	})
end

return l
