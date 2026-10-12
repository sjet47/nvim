return {
    -- Subword motions: like w/e/b, but also stopping inside camelCase and
    -- snake_case words. On Alt so the native word motions stay as they are
    ---@see https://github.com/chrisgrieser/nvim-spider
    "chrisgrieser/nvim-spider",
    keys = {
        { "<A-w>", "<cmd>lua require('spider').motion('w')<cr>", mode = { "n", "o", "x" }, desc = "Next subword" },
        { "<A-e>", "<cmd>lua require('spider').motion('e')<cr>", mode = { "n", "o", "x" }, desc = "End of subword" },
        { "<A-b>", "<cmd>lua require('spider').motion('b')<cr>", mode = { "n", "o", "x" }, desc = "Prev subword" },
    },
}
