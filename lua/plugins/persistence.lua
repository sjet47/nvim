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

        -- "Opened on a project" means started without arguments and with
        -- nothing piped in; config/dirarg.lua turns `nvim <dir>` into exactly
        -- that. The project's session is then restored (and recorded from
        -- then on) with the explorer beside it; without one, Nvim shows its
        -- intro screen. Editing a single file (`nvim foo.go`) neither restores
        -- the project's session nor overwrites it on exit
        vim.api.nvim_create_autocmd("StdinReadPre", {
            callback = function() vim.g.started_with_stdin = true end,
        })
        vim.api.nvim_create_autocmd("VimEnter", {
            nested = true,
            callback = function()
                if vim.fn.argc(-1) ~= 0 or vim.g.started_with_stdin then
                    return
                end
                require("persistence").load()
                -- Tells the UIEnter hook in plugins/snacks.lua to show the
                -- explorer. Not without a session to restore: the explorer's
                -- window would keep Nvim from showing the intro screen
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.bo[buf].buflisted and vim.api.nvim_buf_get_name(buf) ~= "" then
                        vim.g.project_session_restored = true
                        break
                    end
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
