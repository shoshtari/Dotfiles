return {
	"kwakzalver/duckytype.nvim",
	config = function()
		require("duckytype").setup({
			number_of_words = 30,
			highlight = {
				good = "Comment",
				bad = "Error",
				remaining = "Todo",
			},
		})
	end,
}
