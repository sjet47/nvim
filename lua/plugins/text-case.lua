return {
    -- Convert between snake_case, camelCase, PascalCase, CONSTANT_CASE ...
    -- gs + a case letter converts the word under the cursor or the selection
    -- (which-key lists them after gs)
    ---@see https://github.com/johmsalas/text-case.nvim
    "johmsalas/text-case.nvim",
    event = "VeryLazy",
    opts = {
        -- The default `ga` prefix would shadow gai/gao (see plugins/lspconfig.lua)
        prefix = "gs",
    },
}
