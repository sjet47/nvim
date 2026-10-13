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
        current_line_blame_opts = {
            delay = 500,
            -- After the diagnostic of the line, not before it. The default
            -- (100) is below the 4096 of an extmark that names no priority,
            -- as the diagnostic text does, so the blame came first and pushed
            -- the message out of a narrow window
            virt_text_priority = 5000,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        -- The preview and blame popups get their (rounded) border from
        -- 'winborder', like every other float

        -- Git operations happen in lazygit (<leader>gg). These maps are the
        -- part it cannot offer: acting on the hunks of the buffer being edited
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")
            local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

            -- Not ]c / [c: those stay the native motions of diff mode
            map("n", "]h", function() gitsigns.nav_hunk("next") end, "Next hunk")
            map("n", "[h", function() gitsigns.nav_hunk("prev") end, "Prev hunk")
            map("n", "<leader>gp", gitsigns.preview_hunk_inline, "Hunk: preview inline")
            map("n", "<leader>gr", gitsigns.reset_hunk, "Hunk: reset")
            map("x", "<leader>gr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Hunk: reset selected lines")
            map("n", "<leader>gb", function() gitsigns.blame_line({ full = true }) end, "Blame line")
            -- Compare against another revision instead of the index, in every
            -- buffer; an empty answer goes back to the index
            map("n", "<leader>gc", function()
                vim.ui.input({ prompt = "Diff base (branch / commit; empty = back to the index): " }, function(ref)
                    -- nil means the prompt was cancelled
                    if ref == "" then
                        gitsigns.reset_base(true)
                    elseif ref then
                        gitsigns.change_base(ref, true)
                    end
                end)
            end, "Change diff base")
            map({ "o", "x" }, "ih", gitsigns.select_hunk, "inner hunk")
        end,
    },
}
