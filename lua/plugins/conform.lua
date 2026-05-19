return {
	-- Lightweight, fast formatter plugin (replaces null-ls formatting)
	---@see https://github.com/stevearc/conform.nvim
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				go = { "gofmt" },
				json = { "jq" },
			},
			-- Fall back to LSP formatting for filetypes without a formatter above
			format_on_save = {
				timeout_ms = 1000,
				lsp_format = "fallback",
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			require("conform").format({ async = true, lsp_format = "fallback" })
		end, { desc = "Format buffer" })
	end,
}
