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
        vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, { desc = "Diagnostics of this line" })
        -- [d / ]d are Neovim defaults (vim.diagnostic.jump); see `jump` below
        vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Diagnostics to the location list" })

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
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc }) end
                -- Navigation (VSCode-style); prefer snacks pickers for multi-result lookups
                map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
                map("n", "gD", function() Snacks.picker.lsp_type_definitions() end, "Go to type definition")
                map("n", "gi", function() Snacks.picker.lsp_implementations() end, "Go to implementation")
                map("n", "gr", function() Snacks.picker.lsp_references() end, "References")
                -- Call hierarchy: c[a]lls [i]ncoming / [o]utgoing
                map("n", "gai", function() Snacks.picker.lsp_incoming_calls() end, "Incoming calls")
                map("n", "gao", function() Snacks.picker.lsp_outgoing_calls() end, "Outgoing calls")
                -- Hover (also on K, an Nvim default) / signature
                map("n", "gh", vim.lsp.buf.hover, "Hover")
                map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
                -- Refactor (VSCode-style)
                map("n", "cd", vim.lsp.buf.rename, "Rename symbol")
                map("n", "cr", vim.lsp.buf.code_action, "Code action")
                -- Not `cr` in visual mode: there `c` acts right away, and a map
                -- starting with it makes `c` wait 'timeoutlen' for an `r`
                map("x", "<C-.>", vim.lsp.buf.code_action, "Code action")
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
