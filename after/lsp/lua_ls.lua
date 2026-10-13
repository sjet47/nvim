---@see https://luals.github.io/wiki/settings/
-- Neovim runtime / plugin type definitions come from lazydev.nvim
---@type vim.lsp.Config
return {
    settings = {
        Lua = {
            completion = { callSnippet = "Replace" },
            hint = { enable = true },
        },
    },
}
