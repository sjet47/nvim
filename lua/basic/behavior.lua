-- Enable mouse click
vim.o.mouse = "a"

-- Paste with middle-click
-- vim.o.mouse = "v"

-- ignore case except uppercase
vim.o.ignorecase = true
vim.o.smartcase = true

-- Incremental search
vim.o.incsearch = true

-- See multiple spaces as tabstops so <BS> does the right thing
vim.o.softtabstop = 4

-- Convert tab to space
vim.o.expandtab = false

-- Width of shift(<< and >>)
vim.o.shiftwidth = 4

-- Round indent to a multiple of 'shiftwidth', i.e. 3 => 4
vim.o.shiftround = true

-- Indent a new line the same amount as the line just typed(including copy)
vim.o.autoindent = true
vim.o.smartindent = true

-- New vertical-split pane focus on below
vim.o.splitbelow = true

-- New horizen-split pane focus on right
vim.o.splitright = true

-- Use register '+' as system clipboard
vim.o.clipboard = "unnamedplus"

-- Speed up scrolling
-- vim.o.ttyfast = true

-- Allow open multiple buffers(files) at the same time
vim.o.hidden = true

-- Disable backup and swap file for privacy reason
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Auto reload file when edited outside
vim.o.autoread = true

-- Spell checking. With treesitter only comments and strings are checked;
-- `cjk` leaves Chinese text alone and `camel` splits camelCase words.
-- Accepted words (zg) go to spell/en.utf-8.add. That list is tracked in git
-- but its compiled form is not, so rebuild the latter when missing or stale
local spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
local words, compiled = vim.uv.fs_stat(spellfile), vim.uv.fs_stat(spellfile .. ".spl")
if words and (not compiled or compiled.mtime.sec < words.mtime.sec) then
    vim.cmd("silent! mkspell! " .. vim.fn.fnameescape(spellfile))
end
vim.o.spellfile = spellfile
vim.o.spelllang = "en,cjk"
vim.o.spelloptions = "camel"
-- Don't flag sentences that start with a lowercase letter
vim.o.spellcapcheck = ""
vim.o.spell = true

-- Ask what to do about unsaved changes instead of failing (e.g. :q, :e)
vim.o.confirm = true

-- Preview the effect of :s in a split while typing it
vim.o.inccommand = "split"

-- <C-o>/<C-i> behave like browser history: jumping from the middle of the
-- jumplist drops the entries after it instead of reordering them
vim.o.jumpoptions = "stack"

-- Disable vi-compatible to make vim behave in a more useful way
vim.o.compatible = false
