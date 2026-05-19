return {
    -- Bundled server configs (lsp/*.lua) consumed by the native vim.lsp API
    ---@see https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
    -- mason-lspconfig must install servers before they are enabled
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local common = require("lsp.common")
        local lsps = require("lsp")

        -- Defaults applied to every server (nvim-cmp capabilities)
        vim.lsp.config("*", {
            capabilities = common.capabilities,
        })

        -- Per-server overrides, then enable. Base configs (cmd, filetypes,
        -- root markers) come from nvim-lspconfig's bundled lsp/*.lua files.
        for _, lsp in pairs(lsps) do
            if lsp.config then
                vim.lsp.config(lsp.name, lsp.config)
            end
            vim.lsp.enable(lsp.name)
        end

        -- Global diagnostic mappings.
        -- See `:help vim.diagnostic.*` for documentation.
        vim.keymap.set('n', '<space>d', vim.diagnostic.open_float)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            -- Formatting is handled by conform.nvim (<leader>f)

            -- Highlight other references of the symbol under the cursor
            -- (replaces the dropped nvim-treesitter-refactor module)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client and client:supports_method('textDocument/documentHighlight') then
                local hl = vim.api.nvim_create_augroup('UserLspDocHighlight', { clear = false })
                vim.api.nvim_clear_autocmds({ group = hl, buffer = ev.buf })
                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    group = hl, buffer = ev.buf, callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    group = hl, buffer = ev.buf, callback = vim.lsp.buf.clear_references,
                })
            end
        end,
        })

        vim.diagnostic.config({
            virtual_text = true,
            update_in_insert = false,
            underline = true,
            severity_sort = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = " ",
                    [vim.diagnostic.severity.INFO] = " ",
                },
            },
            float = {
                source = true,
                border = "rounded",
                style = "minimal",
                header = "",
            },
        })
    end
}
