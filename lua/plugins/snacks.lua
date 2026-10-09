-- Focus the explorer sidebar, opening it first if needed
local function explorer_focus()
    local explorer = Snacks.picker.get({ source = "explorer" })[1]
    if explorer then
        explorer:focus()
    else
        Snacks.explorer()
    end
end

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
                    local explorer = Snacks.picker.get({ source = "explorer" })[1]
                    if explorer and vim.api.nvim_win_is_valid(explorer.main) then
                        vim.api.nvim_set_current_win(explorer.main)
                    end
                end)
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
    },
    keys = {
        -- Explorer
        { "<leader>e", explorer_focus, desc = "Explorer: focus" },
        -- Find (search args are passed after `--`, e.g. `foo -- -g *.lua`)
        { "<C-p>", function() Snacks.picker.files() end, desc = "Find files" },
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
