return {
    -- Rainbow brackets via tree-sitter (replaces archived p00f/nvim-ts-rainbow)
    ---@see https://github.com/HiPhish/rainbow-delimiters.nvim
    "HiPhish/rainbow-delimiters.nvim",
    -- It attaches to buffers as their FileType fires. By VeryLazy that has
    -- already happened for the file given on the command line and for every
    -- buffer a session restores, which then stayed without rainbow colors
    lazy = false,
}
