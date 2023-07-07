-- vim: set foldmethod=marker foldenable:

-- General Options {{{

vim.g.mapleader = " "
vim.opt.backup = false
vim.opt.completeopt = { "menuone", "noinsert" }
vim.opt.foldenable = false
vim.opt.foldmethod = "syntax"
vim.opt.formatoptions:remove({ "o" })
vim.opt.guicursor = "a:block-nCursor"
vim.opt.hidden = true
vim.opt.incsearch = true
vim.opt.list = true
vim.opt.listchars = { tab = "> ", trail = "-", extends = ">", precedes = "<", nbsp = "+" }
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.pastetoggle = "<F10>"
vim.opt.relativenumber = true
vim.opt.scrolloff = 2
vim.opt.shortmess:append("c")
vim.opt.showmode = false
vim.opt.sidescrolloff = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.title = true
vim.opt.undofile = true
vim.opt.wildignore =
	{ ".hg", ".svn", ".git", "*~", "*.png", "*.jpg", "*.gif", "Thumbs.db", "*.min.js", "*.swp", "*.exe" }
vim.opt.wildmode = { "longest", "full" }
vim.opt.wrap = false
vim.opt.writebackup = false

vim.opt.cindent = false
vim.opt.expandtab = false
vim.opt.shiftwidth = 0
vim.opt.smartindent = false
vim.opt.smarttab = false
vim.opt.tabstop = 4

if vim.fn.has("win32") == 1 then
	vim.opt.path = ".\\**"
else
	vim.opt.path = vim.fn.getcwd() .. "/**"
end

if vim.fn.has("termguicolors") then
	vim.opt.termguicolors = true
end

if vim.fn.executable("rg") then
	vim.opt.grepprg = "rg --no-heading --vimgrep"
	vim.opt.grepformat = "%f:%l:%c:%m"
end

-- }}} General Options
-- Netrw {{{

vim.g.netrw_list_hide = "\\.git/$,\\.hg/$,\\.svn/$"
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3

-- }}} Netrw
-- Functions and Autogroups {{{

function _G.dbg(arg)
	print(vim.inspect(arg))
end

local buffercleanupid = vim.api.nvim_create_augroup("BufferCleanup", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = buffercleanupid,
	desc = "Remove unwanted whitespaces",
	callback = function()
		local b = require("buffer")
		b.trim()
	end,
})

local newtemplateid = vim.api.nvim_create_augroup("NewTemplateFile", { clear = true })
vim.api.nvim_create_autocmd("BufNewFile", {
	group = newtemplateid,
	desc = "Fill new buffer with template",
	callback = function()
		local b = require("buffer")
		b.writeskeleton()
	end,
})

-- }}} Functions and Autogroups
-- Keymaps {{{

local noremap = { noremap = true }
local noremapsilent = { noremap = true, silent = true }

-- Toggle 'wrap' option
vim.keymap.set("n", "<Leader>w", function()
	vim.wo.wrap = not vim.wo.wrap
end, noremapsilent)

-- Open vimrc in a new split, picked based on current terminal size
vim.keymap.set("n", "<Leader>v", function()
	require("window").opensplit(vim.env.MYVIMRC)
end, noremapsilent)

-- Open vimrc on top of the current buffer
vim.keymap.set("n", "<Leader>V", function()
	require("window").open(vim.env.MYVIMRC)
end, noremapsilent)

-- Switch between open buffers
vim.keymap.set("n", "<Leader>j", vim.cmd.bnext, noremapsilent)
vim.keymap.set("n", "<Leader>k", vim.cmd.bprev, noremapsilent)

-- Sort selected lines
vim.keymap.set("v", "<Leader>s", ":sort<CR>", noremapsilent)

-- Toggle between relativenumber and norelativenumber
vim.keymap.set("n", "<Leader>n", function()
	vim.wo.relativenumber = not vim.wo.relativenumber
end, noremapsilent)

-- Place current file in the system clipboard
vim.keymap.set("n", "<Leader>y", "<Cmd>%y+<CR>", noremap)

-- Open file browser
vim.keymap.set("n", "<Leader>p", "<Cmd>Vexplore<CR>", noremap)

-- }}} Keymaps
-- Plugins {{{

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	"tpope/vim-surround",
	"tpope/vim-git",
	"tpope/vim-vinegar",
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup()
		end,
	},
	{
		"cespare/vim-toml",
		ft = "toml",
	},
	{
		"hashivim/vim-terraform",
		ft = { "hcl", "terraform" },
	},
	{
		"projekt0n/github-nvim-theme",
		lazy = true,
		priority = 100,
		commit = "0.0.x",
		config = function()
			require("github-theme").setup({
				theme_style = "dark_default",
				dark_float = true,
				hide_inactive_statusline = false,
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "github-nvim-theme" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true, -- false will disable the whole extension
				},
			})
		end,
	},
	{
		"plasticboy/vim-markdown",
		ft = "markdown",
	},
	{
		"junegunn/fzf.vim",
		dependencies = { "junegunn/fzf" },
		cond = function()
			return vim.fn.executable("fzf") == 1
		end,
		keys = {
			"<Leader>F",
			"<Leader>f",
			"<Leader>b",
			"<Leader>r",
		},
		config = function()
			if vim.fn.executable("fd") == 1 then
				vim.env.FZF_DEFAULT_COMMAND = "fd -tf"
			end
			-- Search files known to Git
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<Leader>F", vim.cmd.Files, opts)
			vim.keymap.set("n", "<Leader>f", vim.cmd.GFiles, opts)
			vim.keymap.set("n", "<Leader>b", vim.cmd.Buffers, opts)
			vim.keymap.set("n", "<Leader>r", vim.cmd.Rg, opts)
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			{
				"L3MON4D3/LuaSnip",
				version = "1.*",
				config = function()
					require("snippets")
				end,
			},
			{
				"hrsh7th/cmp-nvim-lsp",
			},
			{
				"saadparwaiz1/cmp_luasnip",
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							-- do nothing
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "nvim-cmp", "cmp-nvim-lsp" },
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

			lspconfig.terraformls.setup({
				capabilities = capabilities,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set({ "n", "v" }, "<leader>x", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)

					local lspbuffercleanupid = vim.api.nvim_create_augroup("LspBufferCleanup", { clear = true })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = lspbuffercleanupid,
						desc = "Remove unwanted whitespaces from LSP buffer",
						callback = function()
							vim.lsp.buf.format({ async = true })
						end,
					})
				end,
			})
		end,
	},
}

local opts = {
	ui = {
		icons = {
			cmd = "",
			config = "",
			event = "",
			ft = "",
			init = "",
			keys = "",
			plugin = "",
			runtime = "",
			source = "",
			start = "",
			task = "",
			lazy = "",
		},
	},
}

require("lazy").setup(plugins, opts)

-- }}} Plugins
