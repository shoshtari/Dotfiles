
return { 
	"catppuccin/nvim", 
	name = "catppuccin", 
	priority = 1000,
	config = function()
		vim.cmd.colorscheme "catppuccin"
		vim.opt.background = "light"
	end 
}
