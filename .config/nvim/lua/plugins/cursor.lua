return {
	"gen740/SmoothCursor.nvim",
	config = function()
		require("smoothcursor").setup({
			type = "default",
			fancy = {
				enable = true,
			},
		})
	end,
}
