-- Parsers to install. Treesitter is enabled for every filetype that has a
-- parser (see the FileType autocmd below), so one added by hand with
-- `:TSInstall` works without being listed; the list is what a new machine gets
local langs = {
    "c",
    "cpp",
    "go",
    "rust",
    "python",
    "lua",
    "bash",
    "json",
    "proto",
    "yaml",
    "toml",
    "dockerfile",
    "gomod",
    "diff",
    "markdown",
    "markdown_inline",
    "hyprlang",
    "qmljs",
    "css",
    "desktop",
    "zsh",
    "ini",
    "gitcommit",
    "git_rebase",
    "gosum",
    "gowork",
    "ocaml",
    "ocaml_interface",
    "ocamllex",
    "menhir",
}

-- Whether `lang` comes with a query file of that name (highlights, indents ...)
local function has_query(lang, name)
    local ok, query = pcall(vim.treesitter.query.get, lang, name)
    return ok and query ~= nil
end

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
                callback = function(ev)
                    -- Go by the parser a filetype maps to rather than its name:
                    -- `sh` files are parsed as bash
                    local lang = vim.treesitter.language.get_lang(ev.match)
                    -- Nothing to do without a parser for it
                    if not lang or not vim.treesitter.language.add(lang) then
                        return
                    end
                    -- Highlighting (skip very large buffers). Only with a
                    -- highlights query: starting treesitter turns the regex
                    -- syntax off, which would leave the buffer without colors
                    if vim.api.nvim_buf_line_count(ev.buf) <= 10000 and has_query(lang, "highlights") then
                        pcall(vim.treesitter.start, ev.buf, lang)
                    end
                    -- Experimental treesitter-based indentation, for the
                    -- languages that have indent queries
                    if has_query(lang, "indents") then
                        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
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
                { "af", "@function.outer", "a function" },
                { "if", "@function.inner", "inner function" },
                { "ac", "@class.outer", "a class" },
                { "ic", "@class.inner", "inner class" },
                { "ai", "@conditional.outer", "a conditional" },
                { "ii", "@conditional.inner", "inner conditional" },
                { "al", "@loop.outer", "a loop" },
                { "il", "@loop.inner", "inner loop" },
                { "ab", "@block.outer", "a block" },
                { "ib", "@block.inner", "inner block" },
                { "aa", "@parameter.outer", "a parameter" },
                { "ia", "@parameter.inner", "inner parameter" },
            }
            for _, s in ipairs(selects) do
                vim.keymap.set({ "x", "o" }, s[1], function() select.select_textobject(s[2], "textobjects") end, { desc = s[3] })
            end

            -- Move between text objects
            local moves = {
                { "]m", "goto_next_start", "@function.outer", "Next function start" },
                { "]]", "goto_next_start", "@class.outer", "Next class start" },
                { "]M", "goto_next_end", "@function.outer", "Next function end" },
                { "][", "goto_next_end", "@class.outer", "Next class end" },
                { "[m", "goto_previous_start", "@function.outer", "Prev function start" },
                { "[[", "goto_previous_start", "@class.outer", "Prev class start" },
                { "[M", "goto_previous_end", "@function.outer", "Prev function end" },
                { "[]", "goto_previous_end", "@class.outer", "Prev class end" },
            }
            for _, m in ipairs(moves) do
                vim.keymap.set({ "n", "x", "o" }, m[1], function() move[m[2]](m[3], "textobjects") end, { desc = m[4] })
            end
        end,
    },
}
