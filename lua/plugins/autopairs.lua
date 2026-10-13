return {
    -- A super powerful autopair plugin for Neovim that supports multiple characters
    ---@see https://github.com/windwp/nvim-autopairs
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
        check_ts = true,
    },
}
