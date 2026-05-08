return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      -- 1. Move to the right
      view = {
        side = "right",
        width = 35,
      },
      -- 2. Show LSP errors/warnings (diagnostics)
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
      -- Additional settings you might like:
      renderer = {
        highlight_opened_files = "all",
      },
    })

    -- Keymap
    vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")

    -- 3. Auto-close when focus is lost
    -- This creates an autocommand that closes the tree whenever you switch to another buffer
    vim.api.nvim_create_autocmd("BufLeave", {
      group = vim.api.nvim_create_augroup("NvimTreeCloseOnLeave", { clear = true }),
      pattern = "NvimTree_*",
      callback = function()
        require("nvim-tree.api").tree.close()
      end,
    })
  end,
}
-- return {
--   "nvim-neo-tree/neo-tree.nvim",
--   version = "*",
--   lazy = false,
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-tree/nvim-web-devicons",
--     "MunifTanjim/nui.nvim",
--   },
--   config = function()
--     require("neo-tree").setup({
--       close_if_last_window = true,
--       enable_diagnostics = true,
--       update_cwd = true,
--       filesystem = {
--         follow_current_file = {
--           enabled = true,
--         },
--         hijack_netrw_behavior = "open_current",
--       },
--       default_component_configs = {
--         diagnostics = {
--           symbols = {
--             hint = "",
--             info = "",
--             warning = "",
--             error = "",
--           },
--         },
--       },
--       window = {
--         position = "right",
--       },
--     })
--     vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>")
--   end,
-- }
