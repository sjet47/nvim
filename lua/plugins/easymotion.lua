return {
    -- Vim motions on speed: jump to any character with a label
    ---@see https://github.com/easymotion/vim-easymotion
    "easymotion/vim-easymotion",
    keys = {
        { "f", "<Plug>(easymotion-f)", mode = { "n", "x", "o" }, desc = "EasyMotion f" },
        { "F", "<Plug>(easymotion-F)", mode = { "n", "x", "o" }, desc = "EasyMotion F" },
    },
    init = function()
        -- Only f/F are wanted; don't claim the <Leader><Leader> prefix
        vim.g.EasyMotion_do_mapping = 0
    end,
}
