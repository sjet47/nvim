---@see https://taplo.tamasfe.dev/cli/usage/language-server.html
-- Same server and formatter options as VSCode's Even Better TOML
return {
    name = "taplo",
    config = {
        settings = {
            evenBetterToml = {
                schema = { enabled = false },
                formatter = {
                    alignComments = true,
                    alignEntries = false,
                    allowedBlankLines = 2,
                    arrayAutoCollapse = true,
                    arrayTrailingComma = true,
                    columnWidth = 1,
                    compactArrays = true,
                    compactEntries = false,
                    compactInlineTables = true,
                    indentEntries = true,
                    indentTables = true,
                },
            },
        },
    },
}
