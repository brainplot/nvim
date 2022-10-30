return require('packer').startup(function()
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Comment chunks of text
	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}

	-- Surround chunks of text with symbols
	use { 'tpope/vim-surround' }

	-- Git runtime files
	use { 'tpope/vim-git' }

	-- Git client
	use { 'tpope/vim-fugitive' }

	-- Always keep nvim's cwd in the project root
	use {
		'airblade/vim-rooter',
		config = function()
			vim.g.rooter_silent_chdir = 1
		end,
	}

	-- TOML support
	use { 'cespare/vim-toml', ft = 'toml' }

	-- Hashicorp Configuration Language (HCL) and Terraform support
	use {
		'hashivim/vim-terraform',
		ft = { 'hcl', 'terraform' },
		config = function()
			vim.g.terraform_align = 1
			vim.g.terraform_fmt_on_save = 1
		end,
	}

	-- Color scheme
	use {
		'projekt0n/github-nvim-theme',
		config = function()
			require('github-theme').setup({
				theme_style = 'dark_default',
				dark_float = true,
				hide_inactive_statusline = false,
			})
		end,
	}

	-- Statusline for displaying info about the current buffer
	use {
		'nvim-lualine/lualine.nvim',
		after = 'github-nvim-theme',
		config = function()
			require('lualine').setup({
				options = {
					icons_enabled = false,
					theme = 'auto',
				}
			})
		end
	}

	-- Enhanced highlighting for C++ files
	use {
		'octol/vim-cpp-enhanced-highlight',
		ft = 'cpp',
		config = function()
			vim.g.cpp_class_decl_highlight = 1
			vim.g.cpp_class_scope_highlight = 1
			vim.g.cpp_concepts_highlight = 1
			vim.g.cpp_member_variable_highlight = 1
			vim.g.cpp_posix_standard = 1
		end,
	}

	-- Treesitter for better syntax highlighting
	use {
		'nvim-treesitter/nvim-treesitter',
		config = function()
			require'nvim-treesitter.configs'.setup {
				highlight = {
					enable = true, -- false will disable the whole extension
				},
			}
		end,
	}

	-- Enhanced Markdown support
	use { 'plasticboy/vim-markdown', ft = 'markdown' }

	-- PowerShell support
	use { 'pprovost/vim-ps1', ft = 'ps1' }

	-- Rust support
	use { 'rust-lang/rust.vim', ft = 'rust' }

	-- fzf support
	use {
		'junegunn/fzf',
		cond = function()
			return vim.fn.executable 'fzf' == 1
		end,
	}
	use {
		'junegunn/fzf.vim',
		requires = 'junegunn/fzf',
		keys = {
			'<Leader>F',
			'<Leader>f',
			'<Leader>b',
			'<Leader>r',
		},
		config = function()
			if vim.fn.executable 'fd' == 1 then
				vim.env.FZF_DEFAULT_COMMAND = 'fd -tf'
			end
			-- Search files known to Git
			local opts = { noremap = true, silent = true }
			vim.api.nvim_set_keymap('n', '<Leader>F', '<Cmd>Files<CR>', opts)
			vim.api.nvim_set_keymap('n', '<Leader>f', '<Cmd>GFiles<CR>', opts)
			vim.api.nvim_set_keymap('n', '<Leader>b', '<Cmd>Buffers<CR>', opts)
			vim.api.nvim_set_keymap('n', '<Leader>r', '<Cmd>Rg<CR>', opts)
		end,
	}

	-- Language Server Protocol
	use { 'neovim/nvim-lspconfig' }

	-- Snippet support
	use {
		'L3MON4D3/LuaSnip',
		config = function()
			require "snippets"
		end
	}

	use { 'saadparwaiz1/cmp_luasnip', after = "LuaSnip" }

	-- Completion Support
	use {
		'hrsh7th/nvim-cmp',
		requires = {
			'hrsh7th/cmp-buffer',
			{
				'hrsh7th/cmp-nvim-lsp',
				requires = 'neovim/nvim-lspconfig',
				config = function()
					capabilities = require('cmp_nvim_lsp').default_capabilities()
					require('lsp').setup{
						capabilities = capabilities
					}
				end,
			}
		},
		config = function()
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				}, {
					{
						name = 'buffer',
						option = {
							get_bufnrs = function()
								local bufs = {}
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									bufs[vim.api.nvim_win_get_buf(win)] = true
								end
								return vim.tbl_keys(bufs)
							end
						}
					},
				}),
				mapping = {
					['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
					['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
					['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
					['<C-e>'] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					['<C-p>'] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end,
					['<C-n>'] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end,
					['<CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.close()
							vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n')
						else
							fallback()
						end
					end, {'i', 's'}),
					['<TAB>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = true })
						elseif luasnip.expand_or_jumpable() then
							vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
						else
							fallback()
						end
					end, {'i', 's'}),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
						else
							fallback()
						end
					end, {'i', 's'}),
				},
			}
		end
	}
end)
