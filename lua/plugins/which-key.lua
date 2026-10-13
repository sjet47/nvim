return {
    -- Displays a popup with possible key bindings of the command you started typing
    ---@see https://github.com/folke/which-key.nvim
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- Names for the key groups, which otherwise show as "+13 keymaps"
        spec = {
            { "<leader>b", group = "buffer" },
            { "<leader>c", group = "quickfix" },
            { "<leader>f", group = "find", mode = { "n", "x" } },
            { "<leader>g", group = "git", mode = { "n", "x" } },
            { "<leader>p", group = "session" },
            { "<leader>s", group = "search", mode = { "n", "x" } },
            { "<leader>u", group = "toggle" },
            { "<leader>y", group = "yank", mode = { "n", "x" } },
            { "gs", group = "text-case", mode = { "n", "x" } },
            { "ga", group = "calls" },
        },
    },
}
