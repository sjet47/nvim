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

            -- Add missing / drop unused imports on save (gofmt in conform only formats)
            local group = vim.api.nvim_create_augroup("UserGoOrganizeImports", { clear = false })
            vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = group,
                buffer = bufnr,
                callback = function()
                    local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
                    params.context = { only = { "source.organizeImports" }, diagnostics = {} }
                    local res = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
                    for _, action in ipairs(res and res.result or {}) do
                        if action.edit then
                            vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                        end
                    end
                end,
            })
        end,
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
                semanticTokens = true,
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
