---@see https://github.com/ocaml/ocaml-lsp
---@see https://github.com/ocaml/ocaml-lsp/blob/master/ocaml-lsp-server/docs/ocamllsp/config.md
-- Not installed through mason: see `external` in util/lsp.lua
---@type vim.lsp.Config
return {
    settings = {
        -- Hover shows the type expanded one more level with each K / gh
        extendedHover = { enable = true },
        inlayHints = {
            hintPatternVariables = true,
            hintLetBindings = true,
            hintFunctionParams = true,
        },
    },
}
