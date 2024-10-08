return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.formatting.autopep8,
				null_ls.builtins.completion.spell,
			},
			null_ls.builtins.diagnostics.flake8.with({extra_args = {"--max-line-length", "120"}})
		})

		vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})
	end
}
