vim.g.mapleader = ","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)



local opt = {}
require("lazy").setup("plugins")


-- require("lualine").setup {
-- 	options = {
-- 		theme = 'auto'
-- 	}
-- }
package.path = package.path .. ";/home/mpc/.config/nvim/?.lua"
-- require("evil_lualine")
require('vim-commands')
