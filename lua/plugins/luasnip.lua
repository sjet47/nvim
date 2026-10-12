return {
    -- Snippet Engine for Neovim written in Lua.
    ---@see https://github.com/L3MON4D3/LuaSnip
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
        -- VSCode-format snippets from snippets/ (see its package.json for
        -- the filetype of each file). snippets/local/ has the same layout but
        -- is git-ignored: a place for snippets that must not leave this machine
        local dir = vim.fn.stdpath("config") .. "/snippets"
        local paths = { dir }
        if vim.uv.fs_stat(dir .. "/local/package.json") then
            table.insert(paths, dir .. "/local")
        end
        require("luasnip.loaders.from_vscode").lazy_load({ paths = paths })
    end,
}
