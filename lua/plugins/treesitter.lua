return {
    {
        -- Provide a simple and easy way to use the interface for tree-sitter in Neovim
        -- Provide some basic functionality such as highlighting based on it
        ---@see https://github.com/nvim-treesitter/nvim-treesitter
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                sync_install = false,
                ensure_installed = {
                    "c",
                    "cpp",
                    "go",
                    "rust",
                    "python",
                    "lua",
                    "bash",
                    "json",
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                    disable = function(_, bufnr) -- Disable in large buffers
                        return vim.api.nvim_buf_line_count(bufnr) > 10000
                    end,
                },
                incremental_selection = {
                    enable = false,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        node_decremental = "<BS>",
                        scope_incremental = "<TAB>",
                    },
                },
                -- enable =
                indent = {
                    enable = true,
                },
                -- Rainbow brackets are provided by rainbow-delimiters.nvim
                -- https://github.com/windwp/nvim-ts-autotag
                autotag = {
                    enable = true,
                },
                -- https://github.com/RRethy/nvim-treesitter-endwise
                endwise = {
                    enable = true,
                },
                -- nvim-treesitter/nvim-treesitter-refactor
                refactor = {
                    highlight_definitions = {
                        enable = true,
                        -- Set to false if you have an `updatetime` of ~100.
                        clear_on_cursor_move = true,
                    },
                    highlight_current_scope = { enable = false },
                },
                -- nvim-treesitter/nvim-treesitter-textobjects
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["ai"] = "@conditional.outer",
                            ["ii"] = "@conditional.inner",
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",
                        },
                    },
                    swap = {
                        enable = false,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                                ["<leader>A"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                },
            })
        end,
    },
    {
        -- Refactor modules for nvim-treesitter
        ---@see https://github.com/nvim-treesitter/nvim-treesitter-refactor
        "nvim-treesitter/nvim-treesitter-refactor",
        dependencies = { "nvim-treesitter" }
    },
    {
        -- Syntax aware text-objects, select, move, swap, and peek support
        ---@see https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter" }
    },
    {
        -- Autoclose and autorename html tag, works with html,tsx,vue,svelte,php,rescript
        ---@see https://github.com/windwp/nvim-ts-autotag
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter" }
    },
    {
        -- Wisely add end-statement in ruby, Lua, Vimscript, etc
        ---@see https://github.com/RRethy/nvim-treesitter-endwise
        "RRethy/nvim-treesitter-endwise",
        dependencies = { "nvim-treesitter" }
    },
}
