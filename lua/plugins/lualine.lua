return {
    -- A blazing fast and easy to configure Neovim statusline written in Lua
    ---@see https://github.com/nvim-lualine/lualine.nvim
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- In-flight LSP work ($/progress), e.g. gopls loading a big workspace.
        -- Keyed by client id, then progress token; an entry lives from the
        -- `begin` notification until the matching `end`.
        ---@type table<integer, table<integer|string, { title: string, message?: string, percentage?: integer }>>
        local lsp_progress = {}
        local group = vim.api.nvim_create_augroup("UserLspProgress", {})

        vim.api.nvim_create_autocmd("LspProgress", {
            group = group,
            callback = function(ev)
                local value = ev.data.params.value
                local tasks = lsp_progress[ev.data.client_id] or {}
                lsp_progress[ev.data.client_id] = tasks

                local token = ev.data.params.token
                if value.kind == "end" then
                    tasks[token] = nil
                else
                    -- `report` carries no title, so keep the one from `begin`
                    local task = tasks[token] or {}
                    task.title = value.title or task.title or ""
                    task.message = value.message
                    task.percentage = value.percentage
                    tasks[token] = task
                end
                require("lualine").refresh()
            end,
        })

        -- A server that exits mid-task never sends `end`
        vim.api.nvim_create_autocmd("LspDetach", {
            group = group,
            callback = function(ev) lsp_progress[ev.data.client_id] = nil end,
        })

        -- Empty when idle, so the section disappears once loading is done
        local function lsp_progress_status()
            local result = {}
            for client_id, tasks in pairs(lsp_progress) do
                local client = vim.lsp.get_client_by_id(client_id)
                for _, task in pairs(tasks) do
                    local text = (client and client.name or "?") .. " " .. task.title
                    if task.message and task.message ~= "" then
                        text = text .. ": " .. task.message
                    end
                    if task.percentage then
                        text = ("%s (%d%%)"):format(text, task.percentage)
                    end
                    table.insert(result, text)
                end
            end
            -- The result is evaluated as a statusline format string
            return (table.concat(result, " | "):gsub("%%", "%%%%"))
        end

        -- Whether another listed buffer has the same file name as this one
        local function name_is_ambiguous()
            local name = vim.fn.expand("%:t")
            if name == "" then
                return false
            end
            local current = vim.api.nvim_get_current_buf()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if buf ~= current and vim.bo[buf].buflisted and vim.fs.basename(vim.api.nvim_buf_get_name(buf)) == name then
                    return true
                end
            end
            return false
        end

        require("lualine").setup({
            -- One statusline across the whole screen ('laststatus' 3, which
            -- lualine sets from this) instead of one under every window
            options = { globalstatus = true },
            sections = {
                -- Just the file name, unless two open files share it: then
                -- the path from the cwd tells them apart
                lualine_c = {
                    { "filename", path = 1, cond = name_is_ambiguous },
                    { "filename", cond = function() return not name_is_ambiguous() end },
                },
                lualine_x = {
                    lsp_progress_status,
                    -- Only worth showing when they are not the usual ones
                    { "encoding", cond = function() return vim.bo.fileencoding ~= "utf-8" end },
                    { "fileformat", cond = function() return vim.bo.fileformat ~= "unix" end },
                    "filetype",
                },
            },
        })
    end,
}
