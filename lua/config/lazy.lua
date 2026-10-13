-- Plugins are installed under a plugins/ subdir of the lazy data directory
local root = vim.fn.stdpath("data") .. "/lazy/plugins"

-- Bootstrap lazy.nvim into that directory too. Anywhere else it counts as a
-- local plugin, which lazy.nvim never updates
local lazypath = root .. "/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- Only non-default options are set; full reference:
-- https://lazy.folke.io/configuration
require("lazy").setup({
    -- Plugin specs are auto-imported from lua/plugins/*.lua
    spec = { { import = "plugins" } },

    root = root,

    -- No plugin here needs a luarocks package. Left enabled, lazy.nvim wants
    -- luarocks (or its own hererocks build) and reports it as missing
    rocks = { enabled = false },
})

-- Set Appearance. Only now, after the plugins, and not from the colorscheme's
-- spec: gitsigns derives the colors of its staged signs from the colorscheme
-- that is active while it loads, and derived from onedark they come out too
-- dark to see
vim.cmd("colorscheme onedark")
