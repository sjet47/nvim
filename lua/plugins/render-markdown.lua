return {
    -- Render headings, code blocks, tables, checkboxes ... in place in
    -- markdown buffers (the raw text shows on the cursor line / in insert mode)
    ---@see https://github.com/MeanderingProgrammer/render-markdown.nvim
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
}
