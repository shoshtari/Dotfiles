return {
	{
		"Exafunction/codeium.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({})
		end,
		{
			"github/copilot.vim",
			config = function()
				-- print something
				vim.g.copilot_proxy="localhost:2081"
				-- vim.g.copilot_proxy_strict_ssl=true
			end,
		},
	},
}
