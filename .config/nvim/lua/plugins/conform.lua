-- format on save
return {
	"stevearc/conform.nvim",
	config = {
		format_on_save = function(bufnr)
			local name = vim.api.nvim_buf_get_name(bufnr)
			if name:match("templates/") or name:match("Chart.yaml") then
				return nil -- Don't auto-format Helm templates
			end
			return { timeout_ms = 500, lsp_format = true }
		end,
		formatters_by_ft = {
			go = { "goimports", "gofmt" },
		},
	},
}
