return {
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
        opts = {
            -- Bold function and method names, as in VSCode. A call of a
            -- closure stays red (gopls says variable) but is bold too
            styles = { functions = "bold", methods = "bold" },
            highlights = {
                -- The theme links this to `@namespace`, the capture's name
                -- before Neovim 0.10, which is now undefined: the token is
                -- then invisible and a Go package at a call site
                -- (`pkg.Func()`) keeps treesitter's variable color
                ["@lsp.type.namespace"] = { link = "@module" },
                -- `styles.functions` also covers the `func` keyword: only
                -- the names should stand out
                ["@keyword.function"] = { fg = "${purple}" },
            },
        },
    },
}
