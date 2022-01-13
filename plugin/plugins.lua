return require('packer').startup(function()
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Comment chunks of text
	use { 'tpope/vim-commentary' }

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
				theme_style = 'dark_default'
			})
		end,
	}

	-- Statusline for displaying info about the current buffer
	use {
		'nvim-lualine/lualine.nvim',
		requires = 'projekt0n/github-nvim-theme',
		config = function()
			require('lualine').setup({
				options = {
					icons_enabled = false,
					theme = 'github'
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
	use {
		'rust-lang/rust.vim',
		ft = 'rust',
		config = function()
			vim.g.rustfmt_autosave = 1
		end,
	}

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
			setn('<Leader>F', '<Cmd>GFiles<CR>')
			setn('<Leader>f', '<Cmd>Files<CR>')
			setn('<Leader>b', '<Cmd>Buffers<CR>')
			setn('<Leader>r', '<Cmd>Rg<CR>')
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
		commit = '5bed2dc9f306a1659c68a3de88fc747cf6c1d12d',
		requires = {
			'hrsh7th/cmp-buffer',
			{
				'hrsh7th/cmp-nvim-lsp',
				requires = 'neovim/nvim-lspconfig',
				config = function()
					local capabilities = vim.lsp.protocol.make_client_capabilities()
					capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
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
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
					{ name = 'luasnip' }
				},
				mapping = {
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.close(),
					['<CR>'] = cmp.mapping(function(fallback)
						if vim.fn.pumvisible() == 1 then
							cmp.close()
							vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n')
						else
							fallback()
						end
					end, {'i', 's'}),
					['<TAB>'] = cmp.mapping(function(fallback)
						if vim.fn.pumvisible() == 1 then
							cmp.confirm {
								behavior = cmp.ConfirmBehavior.Insert,
								select = true,
							}
						elseif luasnip.expand_or_jumpable() then
							vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
						else
							fallback()
						end
					end, {'i', 's'}),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if vim.fn.pumvisible() == 1 then
							vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
						elseif luasnip.jumpable(-1) then
							vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
						else
							fallback()
						end
					end, {'i', 's'}),
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
			}
		end
	}
end)
