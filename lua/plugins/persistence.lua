return {
    -- Per-directory (and git branch) sessions: reopen the buffers and window
    -- layout a project was left with
    ---@see https://github.com/folke/persistence.nvim
    "folke/persistence.nvim",
    lazy = true,
    opts = {},
    init = function()
        -- Buffers, layout and cwd only: no empty windows where the explorer
        -- was, no terminals, no fold state
        vim.o.sessionoptions = "buffers,curdir,help,tabpages,winsize,skiprtp"

        -- Sessions are restored, and from then on recorded, only when Nvim is
        -- opened on a project: no file arguments, nothing piped in. Editing a
        -- single file (`nvim foo.go`) neither restores the project's session
        -- nor overwrites it on exit
        vim.api.nvim_create_autocmd("StdinReadPre", {
            callback = function() vim.g.started_with_stdin = true end,
        })
        vim.api.nvim_create_autocmd("VimEnter", {
            nested = true,
            callback = function()
                if vim.fn.argc(-1) == 0 and not vim.g.started_with_stdin then
                    require("persistence").load()
                end
            end,
        })
    end,
    keys = {
        { "<leader>ps", function() require("persistence").load() end, desc = "Session: restore for this directory" },
        { "<leader>pl", function() require("persistence").load({ last = true }) end, desc = "Session: restore the last one" },
        { "<leader>pS", function() require("persistence").select() end, desc = "Session: pick one" },
        { "<leader>pd", function() require("persistence").stop() end, desc = "Session: don't save on exit" },
    },
}
