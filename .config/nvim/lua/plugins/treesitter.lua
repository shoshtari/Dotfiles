return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"lua",
					"python",
					"go",
					"yaml",
					"rust",
					"javascript",
					"typescript",
					"bash",
					"c",
					"cpp",
				},
				auto_install = true,
			})

			-- Enable highlighting for all buffers
			vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
				callback = function(args)
					local buf = args.buf
					pcall(vim.treesitter.start, buf)
				end,
			})

			-- Enable indentation
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(function()
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end)
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({})
		end,
	},
}
--return {
--	{
--		"nvim-treesitter/nvim-treesitter",
--		build = ":TSUpdate",
--		config = function()
--			local config = require("nvim-treesitter.configs")
--			config.setup({
--				auto_install = true,
--				ensure_installed = { "lua", "python", "go", "yaml" },
--				highlight = { enable = true },
--				indent = { enable = true },
--			})
--		end,
--	},
--	{
--		"nvim-treesitter/nvim-treesitter-context",
--		config = function()
--			require("treesitter-context").setup({
--				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
--				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
--				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
--				line_numbers = true,
--				multiline_threshold = 20, -- Maximum number of lines to show for a single context
--				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
--				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
--				-- Separator between context and content. Should be a single character string, like '-'.
--				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
--				separator = nil,
--				zindex = 20, -- The Z-index of the context window
--				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
--			})
--		end,
--	},
--}
