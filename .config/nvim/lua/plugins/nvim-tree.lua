return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			update_focused_file = {
				enable = true,
				update_cwd = true,
			},
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			diagnostics = {
				enable = true,
				show_on_dirs = true,
				icons = {
					hint = "",
					info = "",
					warning = "",
					error = "",
				},
			},
		})
		vim.keymap.set("n", "<C-n>", ":NvimTreeToggle <CR>")
		vim.g.nvim_tree_respect_buf_cwd = 1
	end,
}
