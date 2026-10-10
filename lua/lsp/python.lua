---@see https://docs.basedpyright.com/latest/configuration/language-server-settings/
-- Open-source stand-in for Pylance (which is licensed for VS Code only)
return {
    name = "basedpyright",
    config = {
        settings = {
            basedpyright = {
                -- ruff owns import sorting (see plugins/conform.lua)
                disableOrganizeImports = true,
                analysis = {
                    -- basedpyright defaults to the much noisier "recommended"
                    typeCheckingMode = "standard",
                    autoImportCompletions = true,
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "openFilesOnly",
                },
            },
        },
    },
}
