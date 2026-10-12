local group = vim.api.nvim_create_augroup("UserBasic", {})

-- Briefly highlight the yanked text. The default group (IncSearch) shares its
-- background with the visual selection in onedark, so use an amber wash (the
-- theme's yellow at ~35% over the editor background) that keeps syntax colors
local function set_yank_hl() vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#6a604d" }) end
set_yank_hl()
vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_yank_hl })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function() vim.hl.on_yank({ higroup = "YankHighlight" }) end,
})

-- Absolute line numbers while inserting, relative ones otherwise
vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    group = group,
    callback = function(ev)
        -- Leave windows without line numbers (pickers, explorer, ...) alone
        if vim.wo.number then
            vim.wo.relativenumber = ev.event == "InsertLeave"
        end
    end,
})

-- 'autoread' only reloads once something checks the file's timestamp, so do
-- that whenever Nvim regains attention (files get edited from other terminals)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
    group = group,
    callback = function()
        -- :checktime is not allowed in the command-line window
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

-- Reopen a file at the position it was last left at
vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    callback = function(ev)
        -- Commit messages and rebase todos always start at the top
        if vim.bo[ev.buf].filetype:match("^git") then
            return
        end
        local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Strip trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    callback = function(ev)
        local bo = vim.bo[ev.buf]
        -- A trailing space is significant in a patch
        if bo.binary or not bo.modifiable or bo.filetype == "diff" then
            return
        end
        -- Respect a project that opts out through .editorconfig
        local editorconfig = vim.b[ev.buf].editorconfig
        if editorconfig and editorconfig.trim_trailing_whitespace == "false" then
            return
        end
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns keepjumps %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- Terminal output is not prose
vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    callback = function() vim.opt_local.spell = false end,
})
