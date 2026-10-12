local group = vim.api.nvim_create_augroup("UserBasic", {})

-- Briefly highlight the yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.hl.on_yank()
    end,
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
