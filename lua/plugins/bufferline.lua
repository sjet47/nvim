local keys = {
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Close buffer" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
}
-- VSCode-like (Linux): <A-1> ~ <A-9> jump to the Nth tab
for i = 1, 9 do
    table.insert(keys, { "<A-" .. i .. ">", "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", desc = "Go to buffer " .. i })
end

return {
    -- A snazzy buffer line (with tabpage integration) for Neovim built using lua
    ---@see https://github.com/akinsho/bufferline.nvim
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = keys,
    config = function()
        vim.opt.mousemoveevent = true
        require("bufferline").setup({
            options = {
                -- Keep the window layout when closing a tab with the mouse
                close_command = function(n) Snacks.bufdelete(n) end,
                right_mouse_command = function(n) Snacks.bufdelete(n) end,
                diagnostics = "nvim_lsp",
                hover = {
                    enabled = true,
                    delay = 50,
                    reveal = { "close" },
                },
                offsets = {
                    { filetype = "snacks_layout_box", text = "Explorer", separator = true },
                },
            },
        })
    end,
}
