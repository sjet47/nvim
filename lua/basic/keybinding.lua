-- ************************************************************
-- *                           Jump                           *
-- ************************************************************

-- Leader key (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Select all
vim.keymap.set("", "<C-a>", "gg0vG$", { desc = "Select all" })

-- Window navigation with <C-j/k>
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to the window below" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to the window above" })

-- <C-l> jump to end of line (overrides default window-right nav)
vim.keymap.set("n", "<C-l>", "$", { desc = "Jump to end of line" })

-- Mapping <C-m> also catches <CR> (Nvim treats it as <C-m>'s simplified form)
-- unless <CR> has its own mapping, so keep Enter as-is explicitly
vim.keymap.set("n", "<CR>", "<CR>", { desc = "Enter (not <C-m>)" })

-- Save
vim.keymap.set("n", "<C-s>", "<cmd>:w<cr>", { desc = "Save" })

-- Quickfix
vim.keymap.set("n", "<leader>co", "<cmd>copen<cr>", { desc = "Quickfix: open" })
vim.keymap.set("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Quickfix: close" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>zz", { desc = "Quickfix: next item" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>zz", { desc = "Quickfix: prev item" })

-- VSCode-like "Copy Relative Path": yank the cwd-relative path of the current
-- file to the system clipboard, optionally suffixed with `:line` (normal mode)
-- or `:start-end` (visual selection spanning several lines)
local function copy_relative_path(with_line)
    local path = vim.fn.expand("%:.")
    if path == "" then
        vim.notify("Buffer has no file name", vim.log.levels.WARN)
        return
    end
    if with_line then
        -- "v" is the other end of the selection; equals the cursor line in normal mode
        local from, to = vim.fn.line("v"), vim.fn.line(".")
        if from > to then
            from, to = to, from
        end
        path = path .. ":" .. (from == to and from or from .. "-" .. to)
    end
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path)
end

vim.keymap.set({ "n", "x" }, "<leader>yp", function() copy_relative_path(true) end, { desc = "Copy relative path:line" })
vim.keymap.set("n", "<leader>yP", function() copy_relative_path(false) end, { desc = "Copy relative path" })

-- Use jj as Esc
-- vim.keymap.set("i", "jj", "<Esc>")
