local explorer = require("util.explorer")

return {
    -- A collection of QoL plugins: picker, file explorer, notifier,
    -- indent guides, lazygit integration, ...
    ---@see https://github.com/folke/snacks.nvim
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    init = function()
        -- `nvim <dir>` opens the explorer and focuses it on UIEnter;
        -- move focus back to the editor window right after
        vim.api.nvim_create_autocmd("UIEnter", {
            once = true,
            callback = function()
                vim.schedule(function()
                    local picker = explorer.get()
                    -- A project's session was restored (see
                    -- plugins/persistence.lua): show the explorer beside it
                    if not picker and vim.g.project_session_restored then
                        Snacks.explorer({ enter = false })
                        return
                    end
                    if picker and vim.api.nvim_win_is_valid(picker.main) then
                        vim.api.nvim_set_current_win(picker.main)
                    end
                end)
            end,
        })

        -- Toggles under <leader>u. which-key shows the state each one is in
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.diagnostics():map("<leader>ud")
                -- Everywhere, like <C-M-t> (plugins/lspconfig.lua); the
                -- built-in inlay hints toggle is per buffer
                Snacks.toggle({
                    name = "Inlay Hints",
                    get = function() return vim.lsp.inlay_hint.is_enabled() end,
                    set = function(state) vim.lsp.inlay_hint.enable(state) end,
                }):map("<leader>uh")
                Snacks.toggle({
                    name = "Git Blame Line",
                    get = function() return require("gitsigns.config").config.current_line_blame end,
                    set = function(state) require("gitsigns").toggle_current_line_blame(state) end,
                }):map("<leader>ub")
                -- Honored by format_on_save in plugins/conform.lua and by the
                -- trailing whitespace autocmd in basic/autocmd.lua
                Snacks.toggle({
                    name = "Format on Save",
                    get = function() return not vim.g.disable_autoformat end,
                    set = function(state) vim.g.disable_autoformat = not state end,
                }):map("<leader>uf")
            end,
        })
    end,
    ---@type snacks.Config
    opts = {
        picker = {
            -- Also sets vim.ui.select (replaces telescope-ui-select)
            ui_select = true,
            win = {
                input = {
                    keys = {
                        -- Close straight from insert mode, like telescope did
                        ["<Esc>"] = { "close", mode = { "n", "i" } },
                        ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                        ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                        ["<Down>"] = { "history_forward", mode = { "i", "n" } },
                        ["<Up>"] = { "history_back", mode = { "i", "n" } },
                    },
                },
            },
            sources = {
                explorer = {
                    hidden = false, -- hide dotfiles (toggle with <a-h>)
                    ignored = true, -- but show git-ignored files (toggle with I)
                    layout = { layout = { width = 24, min_width = 24 } },
                    win = {
                        -- <Esc> in the search bar goes back to the tree (keeping
                        -- the filter) instead of closing the whole explorer
                        input = {
                            keys = {
                                ["<Esc>"] = { "toggle_focus", mode = { "n", "i" } },
                            },
                        },
                        list = {
                            keys = {
                                ["L"] = "edit_vsplit",
                                ["H"] = "explorer_close_all",
                            },
                        },
                    },
                },
            },
        },
        explorer = { replace_netrw = true },
        notifier = { enabled = true },
        input = { enabled = true },
        indent = { enabled = true },
        lazygit = { enabled = true },
        -- Skip treesitter, LSP ... for files too big to handle smoothly
        bigfile = { enabled = true },
        -- Smooth scrolling, much shorter than the default 200ms (and 50ms
        -- once a scroll key is held or repeated)
        scroll = {
            enabled = true,
            animate = { duration = { step = 10, total = 50 } },
            animate_repeat = { duration = { step = 5, total = 25 } },
        },
        -- Signs, line numbers, folds and git changes in one column layout
        statuscolumn = { enabled = true },
    },
    keys = {
        -- Explorer
        { "<leader>e", explorer.focus, desc = "Explorer: focus" },
        -- Find (search args are passed after `--`, e.g. `foo -- -g *.lua`)
        -- buffers + recent first, then every file in cwd once you start typing
        { "<C-p>", function() Snacks.picker.smart({ filter = { cwd = true } }) end, desc = "Find files (recent first)" },
        { "<C-f>", function() Snacks.picker.lines() end, desc = "Search in buffer" },
        { "<C-S-m>", function() Snacks.picker.grep() end, desc = "Grep" },
        -- Needs the kitty keyboard protocol; see the <CR> passthrough in basic/keybinding.lua
        { "<C-m>", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP symbols (workspace)" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>fw", function() Snacks.picker.grep_word() end, mode = { "n", "x" }, desc = "Grep word/selection" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
        { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols (buffer)" },
        { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP symbols (workspace)" },
        { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>fh", function() Snacks.picker.help() end, desc = "Help pages" },
        { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification history" },
        { "<leader>f.", function() Snacks.picker.resume() end, desc = "Resume last picker" },
        -- Git
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>gl", function() Snacks.lazygit.log_file() end, desc = "Lazygit: current file log" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
    },
}
