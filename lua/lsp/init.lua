---@type table<string, table> server name -> server spec
-- Auto-load every LSP server spec in this directory. Drop a new
-- `<lang>.lua` here and it is picked up automatically; `init.lua` and
-- `common.lua` are skipped.
local servers = {}
local lsp_dir = vim.fn.stdpath("config") .. "/lua/lsp"
for name, ftype in vim.fs.dir(lsp_dir) do
    local mod = name:match("^(.+)%.lua$")
    if ftype == "file" and mod and mod ~= "init" and mod ~= "common" then
        servers[mod] = require("lsp." .. mod)
    end
end
return servers
