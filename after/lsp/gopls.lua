---@see https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
---@see https://github.com/golang/tools/blob/master/gopls/doc/settings.md
---@type vim.lsp.Config
return {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            -- staticcheck's nilness dataflow analysis never converges on some
            -- heybox-go packages, pinning gopls at ~1.4 cores forever
            staticcheck = false,
            semanticTokens = true,
            -- Complete calls with placeholders for their arguments
            usePlaceholders = true,
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
}
