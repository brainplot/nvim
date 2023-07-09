return {
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
		"akinsho/git-conflict.nvim",
		version = "v1.*",
		config = function()
			require("git-conflict").setup({
				default_mappings = {
					next = "<C-n>",
					prev = "<C-p>",
				},
			})
		end,
	},
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
		config = function()
			require("github-theme").setup()
			vim.cmd.colorscheme("github_dark_tritanopia")
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
				sections = {
					lualine_x = { "require'buffer'.getclients()", "encoding", "fileformat", "filetype" },
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
				version = "v1.*",
				config = function()
					require("snippets")
					vim.keymap.set({ "i", "s" }, "<C-j>", "<Plug>luasnip-next-choice", {})
					vim.keymap.set({ "i", "s" }, "<C-k>", "<Plug>luasnip-prev-choice", {})
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
				-- https://github.com/hrsh7th/nvim-cmp/issues/1621
				preselect = cmp.PreselectMode.None,
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
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
						elseif cmp.visible() and luasnip.expandable() then
							luasnip.expand()
						elseif luasnip.jumpable(1) then
							luasnip.jump(1)
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
			require("lsp").setup({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})
		end,
	},
}
