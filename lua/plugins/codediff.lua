return {
    -- VSCode-style side-by-side diffs (char-level highlights) with a
    -- changed-files explorer and file history
    -- In the diff view: ]c/[c hunks, ]f/[f files, - stage, q quit, g? help
    ---@see https://github.com/esmuellert/codediff.nvim
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
        { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Diff: working tree changes" },
        { "<leader>gD", "<cmd>CodeDiff --staged<cr>", desc = "Diff: staged changes" },
        { "<leader>gf", "<cmd>CodeDiff file HEAD<cr>", desc = "Diff: current file vs HEAD" },
        { "<leader>gh", "<cmd>CodeDiff history %<cr>", desc = "Diff: current file history" },
        { "<leader>gH", "<cmd>CodeDiff history<cr>", desc = "Diff: repo history" },
        { "<leader>gh", ":CodeDiff history<cr>", mode = "x", desc = "Diff: history of selected lines" },
    },
    opts = {},
}
