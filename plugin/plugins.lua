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
			require('github-theme').setup()
		end,
	}

	-- Statusline for displaying info about the current buffer
	use {
		'hoob3rt/lualine.nvim',
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

			local keymap = require('keymap')

			-- Search files known to Git
			keymap.setn('<Leader>F', '<Cmd>GFiles<CR>')
			keymap.setn('<Leader>f', '<Cmd>Files<CR>')
			keymap.setn('<Leader>b', '<Cmd>Buffers<CR>')
			keymap.setn('<Leader>r', '<Cmd>Rg<CR>')
		end,
	}

	-- Language Server Protocol
	use {
		'neovim/nvim-lspconfig',
		config = function()

			local keymap = require('keymap')

			keymap.setn('<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>')
			keymap.setn('K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
			keymap.setn('gD', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
			keymap.setn('<C-K>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
			keymap.setn('1gD', '<Cmd>lua vim.lsp.buf.type_definition()<CR>')
			keymap.setn('gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
			keymap.setn('gR', '<Cmd>lua vim.lsp.buf.rename()<CR>')
			keymap.setn('g0', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>')
			keymap.setn('gW', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
			keymap.setn('gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
			keymap.setn('gx', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
		end,
	}

	-- Snippet support
	use { 'saadparwaiz1/cmp_luasnip', requires = "L3MON4D3/LuaSnip" }

	-- Completion Support
	use {
		'hrsh7th/nvim-cmp',
		requires = {
			'L3MON4D3/LuaSnip',
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
					['<CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					['<Tab>'] = function(fallback)
						if vim.fn.pumvisible() == 1 then
							vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
						elseif luasnip.expand_or_jumpable() then
							vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
						else
							fallback()
						end
					end,
					['<S-Tab>'] = function(fallback)
						if vim.fn.pumvisible() == 1 then
							vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
						elseif luasnip.jumpable(-1) then
							vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
						else
							fallback()
						end
					end,
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
