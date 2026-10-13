---@see https://github.com/clangd/clangd
---@type vim.lsp.Config
return {
    cmd = {
        "clangd",
        "--background-index",
        "--pch-storage=memory",
        "--clang-tidy",
        "--completion-style=detailed",
    },
}
