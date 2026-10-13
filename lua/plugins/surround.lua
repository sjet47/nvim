return {
    -- Surround selections, stylishly
    ---@see https://github.com/kylechui/nvim-surround
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    keys = {
        -- Wrap the word under the cursor / the selection in backticks. These
        -- used to cut and paste the text themselves, which went through the
        -- unnamed register and so replaced the system clipboard
        { "``", "ysiw`", remap = true, desc = "Surround word with backticks" },
        { "``", "S`", mode = "x", remap = true, desc = "Surround selection with backticks" },
    },
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end,
}
