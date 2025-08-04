return {
	{
		{
			"github/copilot.vim",
			config = function()
				-- print something
				vim.g.copilot_proxy = "localhost:2080"
				-- vim.g.copilot_proxy_strict_ssl=true
			end,
		},
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			dependencies = {
				{ "nvim-lua/plenary.nvim", branch = "master" },
			},
			build = "make tiktoken",
			opts = {
				-- See Configuration section for options
				-- set a proxy for the copilot chat 
				proxy = "socks5h://localhost:2080",
			},
		},
	},
}
