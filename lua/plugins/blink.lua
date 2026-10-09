-- Fall back to cmdline history when the completion menu is hidden
-- (in cmdline mode the default <C-j> would execute the command line)
local function feed(keys)
    return function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "n", true)
        return true
    end
end

return {
    -- Performant, batteries-included completion plugin for Neovim
    -- (lsp/path/snippets/buffer/cmdline sources are built in)
    ---@see https://github.com/saghen/blink.cmp
    "saghen/blink.cmp",
    version = "1.*", -- release tags ship the prebuilt fuzzy matcher
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "L3MON4D3/LuaSnip" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "none",
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "fallback" },
            -- <C-i> sends the same terminal code as <Tab>; use <C-Space>
            ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        },
        snippets = { preset = "luasnip" },
        completion = {
            -- Moving through the list only highlights; <Tab> inserts
            list = { selection = { preselect = true, auto_insert = false } },
            menu = { border = "rounded" },
            documentation = { auto_show = true, window = { border = "rounded" } },
        },
        signature = { enabled = true, window = { border = "rounded" } },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        cmdline = {
            keymap = {
                preset = "cmdline",
                ["<C-j>"] = { "select_next", feed("<Down>") },
                ["<C-k>"] = { "select_prev", feed("<Up>") },
            },
            completion = { menu = { auto_show = true } },
        },
    },
}
