-- VSCode-like handling of editor windows and tabs. Loaded after the plugins
-- (see init.lua): unlike the maps in basic/keybinding.lua, these need Snacks

local explorer = require("util.explorer")

-- <C-h> toggle focus between the explorer and the previous editor window
vim.keymap.set("n", "<C-h>", function()
    if explorer.filetypes[vim.bo.filetype] then
        vim.cmd("wincmd p")
    else
        explorer.focus()
    end
end, { desc = "Toggle focus explorer" })

-- Editor windows are non-floating windows that aren't side panels like the explorer
local SIDE_PANEL_FILETYPES = explorer.filetypes

local function is_editor_win(win)
    if vim.api.nvim_win_get_config(win).relative ~= "" then
        return false
    end
    local buf = vim.api.nvim_win_get_buf(win)
    return not SIDE_PANEL_FILETYPES[vim.bo[buf].filetype]
end

-- Editor windows of the current tabpage, ordered top-left to bottom-right
local function editor_wins()
    local wins = {}
    for n = 1, vim.fn.winnr("$") do
        local win = vim.fn.win_getid(n)
        if is_editor_win(win) then
            table.insert(wins, win)
        end
    end
    return wins
end

-- VSCode-like editor group switching: <C-1> ~ <C-9> jump to Nth editor window.
-- Like VSCode, if it doesn't exist yet, open an empty window right of the last one.
for i = 1, 9 do
    vim.keymap.set("n", "<C-" .. i .. ">", function()
        local wins = editor_wins()
        if wins[i] then
            vim.api.nvim_set_current_win(wins[i])
            return
        end
        if #wins == 0 then
            return
        end
        vim.api.nvim_set_current_win(wins[#wins])
        vim.cmd("rightbelow vsplit")
        -- Unlisted (no bufferline tab) and wiped once replaced; buftype stays ""
        -- so the snacks picker still opens files into this window
        local buf = vim.api.nvim_create_buf(false, false)
        vim.bo[buf].bufhidden = "wipe"
        vim.api.nvim_win_set_buf(0, buf)
    end, { desc = "Go to editor window " .. i })
end

-- VSCode-like split: show the current buffer in the adjacent editor window on
-- the given side ("l" or "h"), creating a split there if none, and focus it
local function show_in_side_win(dir)
    local cur = vim.api.nvim_get_current_win()
    local target = vim.fn.win_getid(vim.fn.winnr(dir))
    if target == cur or not is_editor_win(target) then
        vim.cmd(dir == "l" and "rightbelow vsplit" or "leftabove vsplit")
        return
    end
    vim.api.nvim_win_set_buf(target, vim.api.nvim_get_current_buf())
    vim.api.nvim_win_set_cursor(target, vim.api.nvim_win_get_cursor(cur))
    vim.api.nvim_set_current_win(target)
end

-- <C-\> to the right, <C-S-\> to the left. With the kitty keyboard protocol
-- <C-S-\> arrives as <C-S-Bslash> (base key + shift), other terminals may send <C-Bar>
vim.keymap.set("n", "<C-Bslash>", function() show_in_side_win("l") end, { desc = "Show buffer in right window" })
for _, lhs in ipairs({ "<C-S-Bslash>", "<C-Bar>" }) do
    vim.keymap.set("n", lhs, function() show_in_side_win("h") end, { desc = "Show buffer in left window" })
end

-- VSCode-like :q — in the last file window, close the buffer (tab) and show the
-- previously used one instead of leaving the explorer fullscreen; quit nvim
-- once no other buffer is left. Splits and special windows close as usual.
vim.api.nvim_create_user_command("CloseTab", function(opts)
    local bang = opts.bang and "!" or ""
    -- Report failures (e.g. E37 on unsaved changes) the way a native :q does
    -- instead of a Lua traceback
    local function quit(cmd)
        local ok, err = pcall(vim.cmd, cmd .. bang)
        if not ok then
            local msg = tostring(err):match("Vim%b():(.*)$") or tostring(err)
            vim.api.nvim_echo({ { msg } }, true, { err = true })
        end
    end
    local function is_file_win(win) return is_editor_win(win) and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "" end
    local cur = vim.api.nvim_get_current_win()
    local file_wins = vim.tbl_filter(is_file_win, vim.api.nvim_tabpage_list_wins(0))
    if not is_file_win(cur) or #file_wins > 1 then
        quit("quit")
        return
    end
    local cur_buf = vim.api.nvim_get_current_buf()
    local others = vim.tbl_filter(function(b) return b ~= cur_buf and vim.bo[b].buflisted end, vim.api.nvim_list_bufs())
    if #others == 0 then
        quit("qall")
    else
        Snacks.bufdelete({ force = opts.bang })
    end
end, { bang = true, desc = "Close current buffer like a VSCode tab" })

-- Only rewrite a bare `q` / `q!` / `wq` typed on the : command line
local function quit_abbrev(from, to)
    vim.keymap.set("ca", from, function() return (vim.fn.getcmdtype() == ":" and vim.fn.getcmdline() == from) and to or from end, { expr = true })
end
quit_abbrev("q", "CloseTab")
quit_abbrev("wq", "w | CloseTab")

-- ZZ / ZQ natively close the window; route them through CloseTab too.
-- Like the native ZZ, only write when the buffer was modified
vim.keymap.set("n", "ZZ", "<cmd>update | CloseTab<cr>", { desc = "Save and close tab" })
vim.keymap.set("n", "ZQ", "<cmd>CloseTab!<cr>", { desc = "Close tab without saving" })
