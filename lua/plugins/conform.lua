return {
	-- Lightweight, fast formatter plugin (replaces null-ls formatting)
	---@see https://github.com/stevearc/conform.nvim
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		-- Project rule: a buffer inside the `heybox-go` module is formatted the
		-- way `zeus fmt` does it. `zeus fmt` itself rewrites whole packages on
		-- disk, so run the goimports invocation it wraps on the buffer instead.
		-- The project is identified by its go.mod module name, not the directory
		-- name, so git worktrees (checked out under arbitrary names) match too.
		---@type table<string, string|false> go.mod dir -> goimports command
		local heybox_goimports = {}
		local function heybox_formatter(bufnr)
			local root = vim.fs.root(bufnr, "go.mod")
			if not root then
				return nil
			end
			if heybox_goimports[root] == nil then
				local f = io.open(root .. "/go.mod")
				local module = f and f:read("*a"):match("module%s+(%S+)")
				if f then
					f:close()
				end
				local cmd = false
				if module == "heybox-go" then
					-- Prefer the goimports pinned by the zeus toolset. It is
					-- git-ignored, so a worktree borrows the main checkout's.
					cmd = "goimports"
					local git = vim.system(
						{ "git", "-C", root, "rev-parse", "--path-format=absolute", "--git-common-dir" },
						{ text = true }
					):wait()
					local main = git.code == 0 and vim.fs.dirname(vim.trim(git.stdout)) or root
					for _, dir in ipairs({ root, main }) do
						local pinned = dir .. "/.zeus-toolset/bin/goimports"
						if vim.fn.executable(pinned) == 1 then
							cmd = pinned
							break
						end
					end
				end
				heybox_goimports[root] = cmd
			end
			return heybox_goimports[root] or nil
		end

		-- Add missing / drop unused imports via gopls (gofmt only formats)
		local function go_organize_imports(bufnr)
			local client = vim.lsp.get_clients({ bufnr = bufnr, name = "gopls" })[1]
			if not client then
				return
			end
			local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
			params.context = { only = { "source.organizeImports" }, diagnostics = {} }
			local res = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
			for _, action in ipairs(res and res.result or {}) do
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
				end
			end
		end

		require("conform").setup({
			formatters = {
				-- Also simplify code (e.g. redundant composite literal types)
				gofmt = { prepend_args = { "-s" } },
				zeus_fmt = {
					command = function(_, ctx)
						return heybox_formatter(ctx.buf) or "goimports"
					end,
					args = { "-local", "heybox-go", "-srcdir", "$DIRNAME" },
					-- `zeus fmt` skips generated code
					condition = function(_, ctx)
						local head = vim.api.nvim_buf_get_lines(ctx.buf, 0, 20, false)
						return not table.concat(head, "\n"):find("Code generated .* DO NOT EDIT")
					end,
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				go = function(bufnr)
					return heybox_formatter(bufnr) and { "zeus_fmt" } or { "gofmt" }
				end,
				json = { "jq" },
				python = { "ruff_organize_imports", "ruff_format" },
			},
			-- Fall back to LSP formatting for filetypes without a formatter above
			format_on_save = function(bufnr)
				-- goimports (zeus_fmt) fixes imports itself, and running gopls
				-- first leaves groups it then refuses to reorder
				if vim.bo[bufnr].filetype == "go" and not heybox_formatter(bufnr) then
					go_organize_imports(bufnr)
				end
				-- protols formats with clang-format, bashls with shfmt and yamlls
				-- with prettier, which would restyle whole files nobody formatted
				-- before; keep that manual (<leader>f)
				local manual = { proto = true, sh = true, bash = true, yaml = true }
				if manual[vim.bo[bufnr].filetype] then
					return nil
				end
				return { timeout_ms = 1000, lsp_format = "fallback" }
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			require("conform").format({ async = true, lsp_format = "fallback" })
		end, { desc = "Format buffer" })
	end,
}
