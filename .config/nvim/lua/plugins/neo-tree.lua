return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      enable_diagnostics = true,
      update_cwd = true,
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_current",
      },
      default_component_configs = {
        diagnostics = {
          symbols = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
      },
      window = {
        position = "right",
      },
    })
    vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>")
  end,
}
