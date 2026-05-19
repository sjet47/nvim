---@see https://github.com/clangd/clangd
return {
    name = "clangd",
    config = {
        -- clangd-specific: pin offset encoding to avoid the multi-encoding warning
        capabilities = {
            offsetEncoding = "utf-8",
        },
        cmd = {
            "clangd",
            "--background-index",
            "--pch-storage=memory",
            "--clang-tidy",
            "--completion-style=detailed",
        },
        init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
        },
    },
}
