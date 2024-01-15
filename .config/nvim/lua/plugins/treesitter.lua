return { 
	'nvim-treesitter/nvim-treesitter',
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			auto_instal = true,
			ensure_installed = {"lua", "python", "go", "yaml"},
			highlight = { enabled = true },
			indent = { enabled = true},
		})
	end 
}
