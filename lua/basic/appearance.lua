-- Display absolute line number
vim.o.number = true
-- Display relative line number for short jump
vim.o.relativenumber = true

-- Left sign column(not known what it does currently)
-- It place a placeholder at the left most column
vim.o.signcolumn = "yes:1"

-- Highlight the line the cursor is on
vim.o.cursorline = true

-- Set an 80 color column border
vim.o.colorcolumn = "80"

-- Number of columns a tab occupied
vim.o.tabstop = 4

-- Highlight recent search result
vim.o.hlsearch = false

-- Dont wrap code
vim.o.wrap = false
vim.o.whichwrap = "<,>,[,]"

-- Display invisible characters
vim.o.list = true
vim.o.listchars = "space:·,tab:→ ,nbsp:␣"

-- Display current edit mode(i.e. INSERT), (disable when using lualine plugin)
vim.o.showmode = false

-- Always display tabs(opened buffers) at the top line
vim.o.showtabline = 2

-- How many line should around the cursor at least
vim.o.scrolloff = 16

-- How many column should around the cursor at least
vim.o.sidescrolloff = 8

-- Use terminal color as neovim color
vim.o.termguicolors = true

-- Default border of floating windows (LSP hover, signature help, ...)
vim.o.winborder = "rounded"

-- Fold by syntax tree (functions, blocks, ...) wherever a treesitter parser
-- is available. Everything starts unfolded: za toggles the fold under the
-- cursor, zM / zR close / open all of them
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
-- Show a closed fold as its first line, syntax highlighting included, without
-- padding the rest of the line with dots
vim.o.foldtext = ""
vim.opt.fillchars:append({ fold = " " })
