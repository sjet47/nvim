---@see https://luals.github.io/wiki/settings/
-- Neovim runtime / plugin type definitions come from lazydev.nvim
return {
    name = "lua_ls",
    config = {
        settings = {
            Lua = {
                completion = { callSnippet = "Replace" },
                hint = { enable = true },
            },
        },
    },
}
