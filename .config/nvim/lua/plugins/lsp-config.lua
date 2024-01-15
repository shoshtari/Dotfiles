return {
	{
		"williamboman/mason.nvim",
		config = function() 
			require('mason').setup()
		end
	}, 
	{
		"williamboman/mason-lspconfig.nvim",
		config = function() 
			require("mason-lspconfig").setup({
    			ensure_installed = { 
					"lua_ls",
					"jedi_language_server",
					"gopls",
					"rust_analyzer"
				}
			})
		end 
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require('lspconfig')
			local opts = {}
			lspconfig.lua_ls.setup({})
			lspconfig.jedi_language_server.setup({})
			lspconfig.gopls.setup({})
			lspconfig.rust_analyzer.setup({})
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
			vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
			vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

			vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
		end

	}
}
