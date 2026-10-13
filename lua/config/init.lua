-- Options passed to lazy.nvim's setup(). Only non-default values are kept;
-- full reference: https://lazy.folke.io/configuration
return {
    -- Plugin specs are auto-imported from lua/plugins/*.lua
    spec = { { import = "plugins" } },

    -- Install plugins under a plugins/ subdir of the lazy data directory
    root = vim.fn.stdpath("data") .. "/lazy/plugins",

    -- No plugin here needs a luarocks package. Left enabled, lazy.nvim wants
    -- luarocks (or its own hererocks build) and reports it as missing
    rocks = { enabled = false },
}
