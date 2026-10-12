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

        -- "Opened on a project" means started with no arguments or with a
        -- single directory, and nothing piped in. `nvim <dir>` then behaves
        -- exactly like `cd <dir> && nvim`: the directory becomes the cwd, its
        -- session is restored (and recorded from then on) and the explorer is
        -- shown (see the UIEnter hook in plugins/snacks.lua).
        -- Editing a single file (`nvim foo.go`) neither restores the project's
        -- session nor overwrites it on exit
        vim.api.nvim_create_autocmd("StdinReadPre", {
            callback = function() vim.g.started_with_stdin = true end,
        })
        vim.api.nvim_create_autocmd("VimEnter", {
            nested = true,
            callback = function()
                if vim.g.started_with_stdin then
                    return
                end
                local argc = vim.fn.argc(-1)
                if argc == 1 and vim.fn.isdirectory(vim.fn.argv(0, -1)) == 1 then
                    vim.cmd.cd(vim.fn.fnameescape(vim.fn.fnamemodify(vim.fn.argv(0, -1), ":p")))
                    -- Get to the state a bare `nvim` starts in before loading
                    -- the session: without the explorer snacks has already
                    -- opened for the directory (restoring into that layout
                    -- loses splits), and without the directory in the arglist
                    -- or as a hidden buffer (it would end up in the session,
                    -- or make an otherwise empty one worth saving)
                    for _, explorer in ipairs(Snacks.picker.get({ source = "explorer" })) do
                        explorer:close()
                    end
                    vim.cmd("%argdelete")
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.fn.isdirectory(vim.api.nvim_buf_get_name(buf)) == 1 then
                            pcall(vim.api.nvim_buf_delete, buf, { force = true })
                        end
                    end
                elseif argc ~= 0 then
                    return
                end
                vim.g.opened_on_project = true
                require("persistence").load()
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
