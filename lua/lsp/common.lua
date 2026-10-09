return {
    -- LSP keymaps are set globally via the `LspAttach` autocmd in
    -- plugins/lspconfig.lua, so per-server `keyAttach` is no longer needed.
    capabilities = require("blink.cmp").get_lsp_capabilities(),
}
