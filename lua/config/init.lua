-- Options passed to lazy.nvim's setup(). Only non-default values are kept;
-- full reference: https://lazy.folke.io/configuration
return {
    -- Plugin specs are auto-imported from lua/plugins/*.lua
    spec = { { import = "plugins" } },

    -- Install plugins under a plugins/ subdir of the lazy data directory
    root = vim.fn.stdpath("data") .. "/lazy/plugins",

    -- Keep lazy-lock.json out of the config repo
    lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",

    ui = {
        icons = {
            cmd = " ",
            config = "",
            event = "",
            ft = " ",
            init = " ",
            import = " ",
            keys = " ",
            lazy = "󰒲 ",
            loaded = "●",
            not_loaded = "○",
            plugin = " ",
            runtime = " ",
            require = "󰢱 ",
            source = " ",
            start = "",
            task = "✔ ",
            list = { "●", "➜", "★", "‒" },
        },
    },
}
