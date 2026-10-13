-- Trial: the message and command-line UI that is new, and still experimental,
-- in Nvim 0.12 (:h ui2). A message too long for the command line is collapsed
-- instead of stopping at a "Press ENTER" prompt; g< shows it in full.
--
-- Enabled on VimEnter, not right away: switched on while Nvim is still
-- starting, `nvim <dir>` (config/dirarg.lua) no longer got the intro screen.
-- pcall: the module does not exist in older versions
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        pcall(function() require("vim._core.ui2").enable({}) end)
    end,
})
