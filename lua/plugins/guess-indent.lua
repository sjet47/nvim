return {
    -- Detect tabs vs spaces and the indent width from the file's content
    -- (basic/behavior.lua only sets the defaults for new or ambiguous files)
    ---@see https://github.com/NMAC427/guess-indent.nvim
    "NMAC427/guess-indent.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
}
