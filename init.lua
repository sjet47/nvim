-- Options, autocmds and the keymaps that need no plugin
require("basic")

-- Skip plugins if running with vscode
if vim.g.vscode then
    return
end

-- `nvim <dir>` becomes a bare `nvim` in that directory. First, because the
-- plugins have to see it that way
require("config.dirarg")
-- lazy.nvim and, through it, the plugins in lua/plugins/
require("config.lazy")
-- VSCode-like editor windows and tabs, built on the plugins
require("config.windows")
