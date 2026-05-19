return {
    -- LSP keymaps are set globally via the `LspAttach` autocmd in
    -- plugins/lspconfig.lua, so per-server `keyAttach` is no longer needed.
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
}
