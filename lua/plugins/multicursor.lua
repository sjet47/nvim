return {
    -- Multiple cursors that work with native motions and operators
    ---@see https://github.com/jake-stewart/multicursor.nvim
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
        -- VSCode-like: add a cursor at the next match of the visual selection
        { "<C-l>", function() require("multicursor-nvim").matchAddCursor(1) end, mode = "x", desc = "Multicursor: add next match" },
        -- VSCode-like <C-S-l>: add a cursor at every match of the visual selection.
        -- Repeats matchAddCursor until it wraps around onto an existing cursor,
        -- since the built-in matchAllAddCursors drops the selections
        {
            "<C-S-l>",
            function()
                local mc = require("multicursor-nvim")
                local count
                repeat
                    count = mc.numCursors()
                    mc.matchAddCursor(1)
                until mc.numCursors() == count
            end,
            mode = "x",
            desc = "Multicursor: add all matches",
        },
    },
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()

        -- Mappings that only exist while there are multiple cursors
        mc.addKeymapLayer(function(layerSet)
            layerSet("n", "<Esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)
    end,
}
