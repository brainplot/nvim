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

	-- One Dark color scheme
	use {
		'rakr/vim-one',
		config = function()
			vim.g.one_allow_italics = 1
			vim.cmd 'colorscheme one'
		end,
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
			-- Search files known to Git
			vim.api.nvim_set_keymap('n', '<Leader>F', '<Cmd>GFiles<CR>', { noremap = true })
			vim.api.nvim_set_keymap('n', '<Leader>f', '<Cmd>Files<CR>', { noremap = true })
			vim.api.nvim_set_keymap('n', '<Leader>b', '<Cmd>Buffers<CR>', { noremap = true })
			vim.api.nvim_set_keymap('n', '<Leader>r', '<Cmd>Rg<CR>', { noremap = true })
		end,
	}

	-- Language Server Protocol
	use {
		'neovim/nvim-lspconfig',
		config = function()
			require 'lsp'
			vim.api.nvim_set_keymap('n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '<C-K>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', '1gD', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', 'gR', '<Cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', 'g0', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', 'gW', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap('n', 'gx', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
		end,
	}
end)
