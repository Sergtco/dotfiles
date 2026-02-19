return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"nvimtools/none-ls.nvim",
			"nvim-lua/plenary.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			local null_ls = require("null-ls")
			return {
				servers = {
					clangd = {},
					gopls = { settings = { gopls = { gofumpt = true } } },
					lua_ls = { settings = { Lua = { format = { enable = false } } } },
					svelte = {},
					marksman = {},
					rust_analyzer = {},
					zls = {},
					tinymist = {},
					ruff = {},
					pyrefly = {},
					ts_ls = {},
				},

				null_ls = {
					sources = {
						null_ls.builtins.diagnostics.golangci_lint,
						null_ls.builtins.formatting.alejandra,
						null_ls.builtins.formatting.typstyle,
						null_ls.builtins.formatting.clang_format,
						null_ls.builtins.formatting.prettier,
						null_ls.builtins.formatting.stylua,
					},
				},
			}
		end,
		config = function(_, opts)
			local on_attach = function(_, bufnr)
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				local fzf = require("fzf-lua")
				vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, bufopts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "grn", vim.lsp.buf.rename, bufopts)
				vim.keymap.set("n", "grr", fzf.lsp_references, bufopts)
				vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "<leader>w", vim.lsp.buf.format, bufopts)
			end

			for server, config in pairs(opts.servers) do
				config.on_attach = on_attach
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end

			require("null-ls").setup({
				sources = opts.null_ls.sources,
				capabilities = require("blink.cmp").get_lsp_capabilities({}),
				on_attach = on_attach,
			})

			vim.diagnostic.config({
				virtual_text = true,
			})
		end,
	},
}
