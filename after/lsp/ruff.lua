---@see https://docs.astral.sh/ruff/editors/setup/#neovim
-- Lint diagnostics + code actions; type info comes from basedpyright (see basedpyright.lua)
---@type vim.lsp.Config
return {
    on_attach = function(client)
        -- Leave hover to basedpyright
        client.server_capabilities.hoverProvider = false
    end,
}
