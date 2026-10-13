-- What the rest of the config needs to know about the snacks explorer sidebar
local M = {}

-- Filetypes of the windows the sidebar is made of
---@type table<string, true>
M.filetypes = {
    snacks_picker_list = true,
    snacks_picker_input = true,
    snacks_layout_box = true,
}

-- The explorer's picker, if the sidebar is open
---@return snacks.Picker?
function M.get() return Snacks.picker.get({ source = "explorer" })[1] end

-- Focus the sidebar, opening it first if needed
function M.focus()
    local picker = M.get()
    if picker then
        picker:focus()
    else
        Snacks.explorer()
    end
end

return M
