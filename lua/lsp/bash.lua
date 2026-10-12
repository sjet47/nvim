---@see https://github.com/bash-lsp/bash-language-server
-- Lint diagnostics need `shellcheck` on $PATH (not installed; bashls just
-- skips linting without it). Formatting goes through `shfmt` and is manual
-- only, see plugins/conform.lua
return {
    name = "bashls",
}
