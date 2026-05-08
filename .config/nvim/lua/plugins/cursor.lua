return {
	"gen740/SmoothCursor.nvim",
	config = function()
		require("smoothcursor").setup({
			type = "matrix", -- or default
			fancy = {
				enable = true,
			},

			matrix = { -- Loaded when 'type' is set to "matrix"
				unstop = true, -- Determines if the cursor should stop or not (false means it will stop)
			},

			autostart = true, -- Automatically start SmoothCursor
		})
	end,
}
