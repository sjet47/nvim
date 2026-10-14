return {
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
        opts = {
            highlights = {
                -- The theme links this to `@namespace`, the capture's name
                -- before Neovim 0.10, which is now undefined: the token is
                -- then invisible and a Go package at a call site
                -- (`pkg.Func()`) keeps treesitter's variable color
                ["@lsp.type.namespace"] = { link = "@module" },
            },
        },
    },
}
