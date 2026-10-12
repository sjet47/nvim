---@see https://rust-analyzer.github.io/book/configuration.html
return {
    name = "rust_analyzer",
    config = {
        settings = {
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                cargo = {
                    features = "all",
                    buildScripts = {
                        enable = true,
                    },
                },
                inlayHints = {
                    closureReturnTypeHints = { enable = "always" },
                    discriminantHints = { enable = "always" },
                    lifetimeElisionHints = { enable = "always" },
                },
                procMacro = {
                    enable = true,
                },
            },
        },
    },
}
