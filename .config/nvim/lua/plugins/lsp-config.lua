return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					-- "jedi_language_server",
					"gopls",
					"rust_analyzer",
					"pylsp",
					"clangd",
					"verible",
					"hydra_lsp",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- pylsp and gopls will auto setup
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local opts = {}
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
			})
			-- lspconfig.jedi_language_server.setup({
			-- 	capabilities = capabilities,
			-- })

			-- lspconfig.gopls.setup({
			-- 	capabilities = capabilities,
			-- })
			vim.lsp.config("rust_analyzer", {
				capabilities = capabilities,
			})
			-- lspconfig.pylsp.setup({
			-- 	capabilities = capabilities,
			-- })
			vim.lsp.config("clangd", {
				capabilities = capabilities,
			})
			vim.lsp.config("verible", {
				capabilities = capabilities,
			})
			vim.lsp.config("hydra_lsp", {
				capabilities = capabilities,
			})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
			vim.api.nvim_set_keymap("n", "<CR>", "<CR><Cmd>cclose<CR>", { noremap = false, silent = true })

			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		end,
	},
}
