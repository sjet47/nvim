local M = {}

-- The language servers this config uses: one file per server in after/lsp/,
-- named after the server and holding the overrides of the config that
-- nvim-lspconfig ships for it (see :h lsp-config-merge). To add a server,
-- drop a `<server>.lua` there, even one that only returns {}: it is then
-- installed through mason (plugins/mason.lua) and enabled
-- (plugins/lspconfig.lua).
---@type string[]
M.servers = {}
for name, type in vim.fs.dir(vim.fn.stdpath("config") .. "/after/lsp") do
    local server = name:match("^(.+)%.lua$")
    if server and type ~= "directory" then
        table.insert(M.servers, server)
    end
end
table.sort(M.servers)

return M
