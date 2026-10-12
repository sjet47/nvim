return {
    -- Highlight every occurrence of the word under the cursor (plain text
    -- match, so it works without LSP and covers what visual <C-S-l> selects)
    ---@see https://github.com/nvim-mini/mini.cursorword
    "nvim-mini/mini.cursorword",
    version = "*",
    event = "VeryLazy",
    config = function()
        require("mini.cursorword").setup({ delay = 100 })

        -- Keep the look of the LSP reference highlight this replaces
        -- (the default is an underline)
        local function set_hl()
            vim.api.nvim_set_hl(0, "MiniCursorword", { link = "LspReferenceText" })
            vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { link = "LspReferenceText" })
        end
        set_hl()
        vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })
    end,
}
