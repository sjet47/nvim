-- ************************************************************
-- *                           Jump                           *
-- ************************************************************

-- Leader key (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Select all
vim.keymap.set("", "<C-a>", "gg0vG$")

-- Window navigation with <C-j/k>
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- <C-l> jump to end of line (overrides default window-right nav)
vim.keymap.set("n", "<C-l>", "$", { desc = "Jump to end of line" })

-- <C-h> toggle focus between NvimTree and the previous editor window
vim.keymap.set("n", "<C-h>", function()
  if vim.bo.filetype == "NvimTree" then
    vim.cmd("wincmd p")
  else
    local ok, api = pcall(require, "nvim-tree.api")
    if ok then
      api.tree.focus()
    end
  end
end, { desc = "Toggle focus NvimTree" })

-- VSCode-like editor group switching: <C-1> ~ <C-9> jump to Nth editor window
-- (skips side panels like NvimTree; ordered top-left to bottom-right)
local SIDE_PANEL_FILETYPES = {
  NvimTree = true,
}

for i = 1, 9 do
  vim.keymap.set("n", "<C-" .. i .. ">", function()
    local count = 0
    for n = 1, vim.fn.winnr("$") do
      local win = vim.fn.win_getid(n)
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
      if not SIDE_PANEL_FILETYPES[ft] then
        count = count + 1
        if count == i then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
    end
  end, { desc = "Go to editor window " .. i })
end

-- VSCode-like split: <C-\> open current buffer in a new right split,
-- <C-S-\> (i.e. <C-|>) open in a new left split
vim.keymap.set("n", "<C-Bslash>", "<cmd>rightbelow vsplit<cr>", { desc = "Split window right" })
vim.keymap.set("n", "<C-Bar>", "<cmd>leftabove vsplit<cr>", { desc = "Split window left" })

-- Save
vim.keymap.set("n", "<C-s>", "<cmd>:w<cr>")

-- Quickfix (used by `gr` references list, etc.)
vim.keymap.set("n", "<leader>co", "<cmd>copen<cr>", { desc = "Quickfix: open" })
vim.keymap.set("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Quickfix: close" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>zz", { desc = "Quickfix: next item" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>zz", { desc = "Quickfix: prev item" })

-- Back quote
vim.keymap.set("n", "``", "ciw``<Esc>hp")
vim.keymap.set("v", "``", "s``<Esc>hp")

-- Use jj as Esc
-- vim.keymap.set("i", "jj", "<Esc>")

-- Allow saving of files as sudo when I forgot to start vim using sudo.
vim.keymap.set('c', 'w!!', ':w ! sudo tee % > /dev/null')
