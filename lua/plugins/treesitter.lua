-- Languages to install parsers for and enable treesitter features on
local langs = { "c", "cpp", "go", "rust", "python", "lua", "bash", "json" }

return {
    {
        ---@see https://github.com/nvim-treesitter/nvim-treesitter
        -- `main` branch: required for Neovim 0.12+. The frozen `master`
        -- branch only supports up to Neovim 0.11.
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            -- Install parsers (async; no-op if already present)
            require("nvim-treesitter").install(langs)

            -- The `main` branch does not auto-enable features; do it per filetype.
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("UserTreesitter", {}),
                pattern = langs,
                callback = function(ev)
                    -- Highlighting (skip very large buffers)
                    if vim.api.nvim_buf_line_count(ev.buf) <= 10000 then
                        pcall(vim.treesitter.start)
                    end
                    -- Experimental treesitter-based indentation
                    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    {
        ---@see https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        init = function()
            -- Stop built-in ftplugin maps from shadowing the move maps below
            vim.g.no_plugin_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = { lookahead = true },
                move = { set_jumps = true },
            })

            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")

            -- Select text objects
            local selects = {
                ["af"] = "@function.outer",    ["if"] = "@function.inner",
                ["ac"] = "@class.outer",       ["ic"] = "@class.inner",
                ["ai"] = "@conditional.outer", ["ii"] = "@conditional.inner",
                ["al"] = "@loop.outer",        ["il"] = "@loop.inner",
                ["ab"] = "@block.outer",       ["ib"] = "@block.inner",
            }
            for key, obj in pairs(selects) do
                vim.keymap.set({ "x", "o" }, key, function()
                    select.select_textobject(obj, "textobjects")
                end)
            end

            -- Move between text objects
            local moves = {
                { "]m", "goto_next_start",     "@function.outer" },
                { "]]", "goto_next_start",     "@class.outer" },
                { "]M", "goto_next_end",       "@function.outer" },
                { "][", "goto_next_end",       "@class.outer" },
                { "[m", "goto_previous_start", "@function.outer" },
                { "[[", "goto_previous_start", "@class.outer" },
                { "[M", "goto_previous_end",   "@function.outer" },
                { "[]", "goto_previous_end",   "@class.outer" },
            }
            for _, m in ipairs(moves) do
                vim.keymap.set({ "n", "x", "o" }, m[1], function()
                    move[m[2]](m[3], "textobjects")
                end)
            end
        end,
    },
}
