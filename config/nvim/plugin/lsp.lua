vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	callback = function(_)
		vim.pack.add({
			"https://github.com/neovim/nvim-lspconfig",
			"https://github.com/nvimtools/none-ls.nvim",
			"https://github.com/nvim-lua/plenary.nvim",
		})

		local servers = {
			clangd = {},
			gopls = { settings = { gopls = { gofumpt = true } } },
			emmylua_ls = { settings = { Lua = { completion = { keywordSnippet = "Replace" } } } },
			svelte = {},
			marksman = {},
			rust_analyzer = {},
			zls = {},
			tinymist = {},
			ruff = {},
			pyrefly = {},
			tsgo = {},
		}

		local null_ls = require("null-ls")
		local null_ls_sources = {
			null_ls.builtins.diagnostics.golangci_lint,
			null_ls.builtins.formatting.alejandra,
			null_ls.builtins.formatting.typstyle,
			null_ls.builtins.formatting.clang_format,
			null_ls.builtins.formatting.prettier,
			null_ls.builtins.formatting.stylua,
		}

		local on_attach = function(client, bufnr)
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			local fzf = require("fzf-lua")
			local set = vim.keymap.set
			set("n", "<leader>e", vim.diagnostic.open_float, bufopts)
			set("n", "gD", vim.lsp.buf.declaration, bufopts)
			set("n", "gd", vim.lsp.buf.definition, bufopts)
			set({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, bufopts)
			set("n", "grr", fzf.lsp_references, bufopts)
			set("n", "<leader>w", vim.lsp.buf.format, bufopts)

			if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, bufnr) then
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.MiniCompletion.completefunc_lsp")
			end
		end

		for server, config in pairs(servers) do
			config.on_attach = on_attach
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end

		require("null-ls").setup({
			sources = null_ls_sources,
			on_attach = on_attach,
		})

		vim.diagnostic.config({
			virtual_text = true,
		})
	end,
})
