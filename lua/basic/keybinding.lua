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

-- Filetypes of the snacks explorer sidebar windows
local EXPLORER_FILETYPES = {
  snacks_picker_list = true,
  snacks_picker_input = true,
  snacks_layout_box = true,
}

-- <C-h> toggle focus between the explorer and the previous editor window
vim.keymap.set("n", "<C-h>", function()
  if EXPLORER_FILETYPES[vim.bo.filetype] then
    vim.cmd("wincmd p")
  else
    local explorer = Snacks.picker.get({ source = "explorer" })[1]
    if explorer then
      explorer:focus()
    else
      Snacks.explorer()
    end
  end
end, { desc = "Toggle focus explorer" })

-- Editor windows are non-floating windows that aren't side panels like the explorer
local SIDE_PANEL_FILETYPES = EXPLORER_FILETYPES

local function is_editor_win(win)
  if vim.api.nvim_win_get_config(win).relative ~= "" then
    return false
  end
  local buf = vim.api.nvim_win_get_buf(win)
  return not SIDE_PANEL_FILETYPES[vim.bo[buf].filetype]
end

-- Editor windows of the current tabpage, ordered top-left to bottom-right
local function editor_wins()
  local wins = {}
  for n = 1, vim.fn.winnr("$") do
    local win = vim.fn.win_getid(n)
    if is_editor_win(win) then
      table.insert(wins, win)
    end
  end
  return wins
end

-- VSCode-like editor group switching: <C-1> ~ <C-9> jump to Nth editor window.
-- Like VSCode, if it doesn't exist yet, open an empty window right of the last one.
for i = 1, 9 do
  vim.keymap.set("n", "<C-" .. i .. ">", function()
    local wins = editor_wins()
    if wins[i] then
      vim.api.nvim_set_current_win(wins[i])
      return
    end
    if #wins == 0 then
      return
    end
    vim.api.nvim_set_current_win(wins[#wins])
    vim.cmd("rightbelow vsplit")
    -- Unlisted (no bufferline tab) and wiped once replaced; buftype stays ""
    -- so the snacks picker still opens files into this window
    local buf = vim.api.nvim_create_buf(false, false)
    vim.bo[buf].bufhidden = "wipe"
    vim.api.nvim_win_set_buf(0, buf)
  end, { desc = "Go to editor window " .. i })
end

-- VSCode-like split: show the current buffer in the adjacent editor window on
-- the given side ("l" or "h"), creating a split there if none, and focus it
local function show_in_side_win(dir)
  local cur = vim.api.nvim_get_current_win()
  local target = vim.fn.win_getid(vim.fn.winnr(dir))
  if target == cur or not is_editor_win(target) then
    vim.cmd(dir == "l" and "rightbelow vsplit" or "leftabove vsplit")
    return
  end
  vim.api.nvim_win_set_buf(target, vim.api.nvim_get_current_buf())
  vim.api.nvim_win_set_cursor(target, vim.api.nvim_win_get_cursor(cur))
  vim.api.nvim_set_current_win(target)
end

-- <C-\> to the right, <C-S-\> to the left. With the kitty keyboard protocol
-- <C-S-\> arrives as <C-S-Bslash> (base key + shift), other terminals may send <C-Bar>
vim.keymap.set("n", "<C-Bslash>", function() show_in_side_win("l") end, { desc = "Show buffer in right window" })
for _, lhs in ipairs({ "<C-S-Bslash>", "<C-Bar>" }) do
  vim.keymap.set("n", lhs, function() show_in_side_win("h") end, { desc = "Show buffer in left window" })
end

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
