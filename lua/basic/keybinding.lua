-- ************************************************************
-- *                           Jump                           *
-- ************************************************************

-- Leader key (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Select all
vim.keymap.set("", "<C-a>", "gg0vG$")

-- Window navigation with <C-h/j/k/l>
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Save
vim.keymap.set("n", "<C-s>", "<cmd>:w<cr>")

-- Back quote
vim.keymap.set("n", "``", "ciw``<Esc>hp")
vim.keymap.set("v", "``", "s``<Esc>hp")

-- Use jj as Esc
-- vim.keymap.set("i", "jj", "<Esc>")

-- Allow saving of files as sudo when I forgot to start vim using sudo.
vim.keymap.set('c', 'w!!', ':w ! sudo tee % > /dev/null')
