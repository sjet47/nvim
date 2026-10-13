return {
    -- Bundled server configs (lsp/*.lua) consumed by the native vim.lsp API
    ---@see https://github.com/neovim/nvim-lspconfig
    "neovim/nvim-lspconfig",
    dependencies = {
        -- mason-lspconfig must install servers before they are enabled
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        -- Registers its completion capabilities for every server ("*") as it
        -- loads, which has to happen before the first server starts
        "saghen/blink.cmp",
    },
    config = function()
        -- Base configs (cmd, filetypes, root markers) come from
        -- nvim-lspconfig's lsp/*.lua files; Nvim merges our overrides in
        -- after/lsp/<server>.lua on top of them (:h lsp-config-merge)
        vim.lsp.enable(require("util.lsp").servers)

        -- Global diagnostic mappings.
        -- See `:help vim.diagnostic.*` for documentation.
        vim.keymap.set("n", "<space>d", vim.diagnostic.open_float)
        -- [d / ]d are Neovim defaults (vim.diagnostic.jump); see `jump` below
        vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

        -- Toggle inlay hints globally. A bare Ctrl+Alt (as in VSCode's
        -- hold-to-peek) never reaches a terminal app, so it needs a letter.
        vim.keymap.set({ "n", "i" }, "<C-M-t>", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle inlay hints" })

        -- <Esc> dismisses the hover / signature float without moving the cursor.
        -- Global rather than buffer-local: multicursor.nvim's keymap layer maps
        -- <Esc> buffer-locally and deletes it afterwards, which would take a
        -- buffer-local mapping of ours down with it
        vim.keymap.set("n", "<Esc>", function()
            local win = vim.b.lsp_floating_preview
            if win and vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end, { desc = "Dismiss LSP float" })

        -- Nvim's default gr* LSP maps are covered by the buffer-local ones
        -- below. Left in place they make `gr` wait 'timeoutlen' for a third key
        for _, lhs in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
            pcall(vim.keymap.del, "n", lhs)
        end
        pcall(vim.keymap.del, "x", "gra")

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                -- Navigation (VSCode-style); prefer snacks pickers for multi-result lookups
                vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, opts)
                vim.keymap.set("n", "gD", function() Snacks.picker.lsp_type_definitions() end, opts)
                vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, opts)
                vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, opts)
                -- Call hierarchy: c[a]lls [i]ncoming / [o]utgoing
                vim.keymap.set("n", "gai", function() Snacks.picker.lsp_incoming_calls() end, opts)
                vim.keymap.set("n", "gao", function() Snacks.picker.lsp_outgoing_calls() end, opts)
                -- Hover / signature
                vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)
                -- Refactor (VSCode-style)
                vim.keymap.set("n", "cd", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "cr", vim.lsp.buf.code_action, opts)
                -- Not `cr` in visual mode: there `c` acts right away, and a map
                -- starting with it makes `c` wait 'timeoutlen' for an `r`
                vim.keymap.set("x", "<C-.>", vim.lsp.buf.code_action, opts)
                -- Workspace
                vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
                -- Formatting is handled by conform.nvim (<leader>ff)
                -- Highlighting the word under the cursor is handled by mini.cursorword
            end,
        })

        vim.diagnostic.config({
            -- Inline text for errors and warnings only (as with VSCode's Error
            -- Lens); hints and infos still get signs and underlines
            virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
            update_in_insert = false,
            underline = true,
            severity_sort = true,
            -- Show the diagnostic float after [d / ]d, like the old goto_prev/next
            jump = {
                on_jump = function(_, bufnr) vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false }) end,
            },
            signs = {
                -- Nerd Font glyphs, written as escapes so that tools which
                -- mangle private-use characters can't silently blank them
                text = {
                    [vim.diagnostic.severity.ERROR] = "\u{f057} ",
                    [vim.diagnostic.severity.WARN] = "\u{f071} ",
                    [vim.diagnostic.severity.HINT] = "\u{f400} ",
                    [vim.diagnostic.severity.INFO] = "\u{f06a} ",
                },
            },
            float = {
                source = true,
                border = "rounded",
                style = "minimal",
                header = "",
            },
        })
    end,
}
