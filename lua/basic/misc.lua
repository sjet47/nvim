-- Write new files as UTF-8
vim.o.fileencoding = "utf-8"

-- The length of time Vim waits after you stop typing before it triggers the plugin
vim.o.updatetime = 500

-- Duration in ms of waiting for a mapped sequence to complete
vim.o.timeoutlen = 400

-- Disable netrw (has to happen before plugins are loaded); the snacks explorer
-- takes its place
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
