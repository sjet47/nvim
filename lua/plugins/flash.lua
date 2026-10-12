return {
    -- Jump labels for f/F/t/T: after the target character is typed, every
    -- match in the window gets a label to jump straight to it
    ---@see https://github.com/folke/flash.nvim
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
        modes = {
            char = { jump_labels = true },
        },
    },
}
