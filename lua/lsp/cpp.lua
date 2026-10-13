---@see https://github.com/clangd/clangd
return {
    name = "clangd",
    config = {
        cmd = {
            "clangd",
            "--background-index",
            "--pch-storage=memory",
            "--clang-tidy",
            "--completion-style=detailed",
        },
    },
}
