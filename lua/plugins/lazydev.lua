return {
    -- Configures lua_ls for editing Neovim config: vim.* API and the
    -- types of installed plugins, loaded on demand as they are required
    ---@see https://github.com/folke/lazydev.nvim
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            -- Snacks is a global, so it is never `require`d
            { path = "snacks.nvim", words = { "Snacks" } },
        },
    },
}
