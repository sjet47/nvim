return {
    -- w/e/b/ge that also stop at the subwords of camelCase and snake_case
    -- (the native motions are still there as W/E/B/gE)
    ---@see https://github.com/chrisgrieser/nvim-spider
    "chrisgrieser/nvim-spider",
    keys = {
        { "w", "<cmd>lua require('spider').motion('w')<cr>", mode = { "n", "o", "x" }, desc = "Next subword" },
        { "e", "<cmd>lua require('spider').motion('e')<cr>", mode = { "n", "o", "x" }, desc = "End of subword" },
        { "b", "<cmd>lua require('spider').motion('b')<cr>", mode = { "n", "o", "x" }, desc = "Prev subword" },
        { "ge", "<cmd>lua require('spider').motion('ge')<cr>", mode = { "n", "o", "x" }, desc = "End of prev subword" },
    },
}
