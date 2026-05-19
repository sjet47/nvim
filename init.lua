require("basic")

-- Skip plugins if running with vscode
if vim.g.vscode then
	return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set lazy.nvim path: $HOME/.config/nvim/lazy/lazy.nvim
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

-- Load plugins (specs are auto-imported from lua/plugins/ via config.spec)
require("lazy").setup(require("config"))

-- Set Appearance
vim.cmd("colorscheme onedark")
