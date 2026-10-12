---@see https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
---@see https://github.com/golang/tools/blob/master/gopls/doc/settings.md
return {
    name = "gopls",
    config = {
        on_attach = function(client, bufnr)
            client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                    tokenTypes = { 'namespace', 'type', 'class', 'enum', 'interface', 'struct', 'typeParameter', 'parameter', 'variable', 'property', 'enumMember', 'event', 'function', 'method', 'macro', 'keyword', 'modifier', 'comment', 'string', 'number', 'regexp', 'operator', 'decorator' },
                    tokenModifiers = { 'declaration', 'definition', 'readonly', 'static', 'deprecated', 'abstract', 'async', 'modification', 'documentation', 'defaultLibrary' }
                }
            }
        end,
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
    },
}
