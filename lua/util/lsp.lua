local M = {}

-- The language servers this config uses: one file per server in after/lsp/,
-- named after the server and holding the overrides of the config that
-- nvim-lspconfig ships for it (see :h lsp-config-merge). To add a server,
-- drop a `<server>.lua` there, even one that only returns {}: it is then
-- installed through mason (plugins/mason.lua; see `external` below) and
-- enabled (plugins/lspconfig.lua).
---@type string[]
M.servers = {}
for name, ftype in vim.fs.dir(vim.fn.stdpath("config") .. "/after/lsp") do
    local server = name:match("^(.+)%.lua$")
    if server and ftype ~= "directory" then
        table.insert(M.servers, server)
    end
end
table.sort(M.servers)

-- Servers that come from the language's own toolchain rather than mason, as
-- they have to be built by the compiler the project uses. ocamllsp reads the
-- compiler's .cmt files, so it is installed in each opam switch
-- (`opam install ocaml-lsp-server`) and found on $PATH.
local external = { ocamllsp = true }

-- The servers for mason to install
---@type string[]
M.mason_servers = vim.tbl_filter(function(server) return not external[server] end, M.servers)

return M
