return {
    -- Highlight and search TODO: / FIXME: / BUG: / NOTE: / WARN: ... comments
    ---@see https://github.com/folke/todo-comments.nvim
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
        { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
        { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo comment" },
        ---@diagnostic disable-next-line: undefined-field
        { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Todo comments" },
    },
}
