require("basic")

-- Skip plugins if running with vscode
if vim.g.vscode then
    return
end

-- `nvim <dir>` is treated exactly like `cd <dir> && nvim`: make the directory
-- the cwd and drop the argument, so that from here on it looks like a bare
-- `nvim` (plugins/persistence.lua takes it from there)
if vim.fn.argc(-1) == 1 and vim.fn.isdirectory(vim.fn.argv(0, -1)) == 1 then
    vim.cmd.cd(vim.fn.fnameescape(vim.fn.fnamemodify(vim.fn.argv(0, -1), ":p")))
    vim.cmd("%argdelete")
    -- Nvim still names the first buffer after the directory. Clear that name
    -- the moment the buffer shows up, before the explorer reacts to it
    vim.api.nvim_create_autocmd("BufWinEnter", {
        once = true,
        callback = function(ev)
            if vim.fn.isdirectory(ev.file) == 0 then
                return
            end
            vim.api.nvim_buf_set_name(ev.buf, "")
            -- Renaming leaves the old name behind in a hidden buffer
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if buf ~= ev.buf and vim.fn.isdirectory(vim.api.nvim_buf_get_name(buf)) == 1 then
                    vim.api.nvim_buf_delete(buf, { force = true })
                end
            end
        end,
    })
end

-- Bootstrap lazy.nvim into the directory it installs plugins to (`root` in
-- lua/config/init.lua). Anywhere else it counts as a local plugin, which
-- lazy.nvim never updates: ~/.local/share/nvim/lazy/plugins/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/plugins/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins (specs are auto-imported from lua/plugins/ via config.spec)
require("lazy").setup(require("config"))

require("config.windows")

-- Set Appearance
vim.cmd("colorscheme onedark")
