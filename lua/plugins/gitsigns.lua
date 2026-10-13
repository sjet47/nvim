return {
    -- Super fast git decorations implemented purely in lua/teal
    ---@see https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    -- Only what differs from the defaults, see :h gitsigns-config
    opts = {
        -- changedelete (~) and untracked (┆) keep their default signs
        signs = {
            add = { text = "│" },
            change = { text = "│" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
        },
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        word_diff = true, -- Toggle with `:Gitsigns toggle_word_diff`
        attach_to_untracked = true,
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = { delay = 500 },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        -- The preview and blame popups get their (rounded) border from
        -- 'winborder', like every other float
    },
}
