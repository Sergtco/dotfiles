return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"nvimtools/none-ls.nvim",
		"nvim-lua/plenary.nvim",
	},
	wants = {
		"saghen/blink.cmp",
		"ibhagwan/fzf-lua",
	},

	event = { "BufReadPost", "BufWritePost", "BufNewFile" },

	opts = function()
		local null_ls = require("null-ls")
		return {
			servers = {
				basedpyright = {},
				clangd = {},
				gopls = { settings = { gopls = { gofumpt = true } } },
				lua_ls = { sttings = { Lua = { format = { enable = false } } } },
				marksman = {},
				nil_ls = {},
				rust_analyzer = {},
				zls = {},
			},

			null_ls = {
				sources = {
					null_ls.builtins.diagnostics.golangci_lint,
					null_ls.builtins.formatting.alejandra,
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.clang_format,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.sqlfmt,
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
			vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts)
			vim.keymap.set("n", "gr", fzf.lsp_references, bufopts)
			vim.keymap.set("n", "<leader>a", fzf.lsp_code_actions, bufopts)
			vim.keymap.set("n", "<leader>w", vim.lsp.buf.format, bufopts)
		end

		for server, config in pairs(opts.servers) do
			config.on_attach = on_attach
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			require("lspconfig")[server].setup(config)
		end

		require("null-ls").setup({
			sources = opts.null_ls.sources,
			on_attach = on_attach,
		})
	end,
}
