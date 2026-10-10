---@see https://docs.astral.sh/ruff/editors/setup/#neovim
-- Lint diagnostics + code actions; type info comes from basedpyright (lsp/python.lua)
return {
    name = "ruff",
    config = {
        on_attach = function(client, bufnr)
            -- Leave hover to basedpyright
            client.server_capabilities.hoverProvider = false
        end,
    },
}
