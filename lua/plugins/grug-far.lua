return {
    -- Project-wide search and replace in an editable panel (ripgrep based)
    ---@see https://github.com/MagicDuck/grug-far.nvim
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    opts = {},
    keys = {
        { "<leader>sr", function() require("grug-far").open() end, desc = "Search and replace" },
        -- Prefill the search with the selection
        { "<leader>sr", function() require("grug-far").with_visual_selection() end, mode = "x", desc = "Search and replace selection" },
    },
}
