return {
    {
        -- Portable package manager for Neovim that runs everywhere Neovim runs
        -- Easily install and manage LSP servers, DAP servers, linters, and formatters
        ---@see https://github.com/mason-org/mason.nvim
        "mason-org/mason.nvim",
        config = function(LazyPlugin, opts)
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                }
            })
        end
    },

    {
        -- Bridges mason.nvim with the lspconfig plugin, making it easier to use both plugins together
        ---@see https://github.com/mason-org/mason-lspconfig.nvim
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
        },
        config = function(LazyPlugin, opts)
            local lsp_servers = {}
            for _, lsp in pairs(require("lsp")) do
                table.insert(lsp_servers, lsp.name)
            end

            require("mason-lspconfig").setup({
                -- Servers to install if they're not already installed
                ---@type string[]
                ensure_installed = lsp_servers,

                -- Servers are enabled explicitly in plugins/lspconfig.lua from
                -- the lua/lsp/ specs, so don't let mason enable every server
                -- that happens to be installed.
                automatic_enable = false,
            })
        end
    },
}
