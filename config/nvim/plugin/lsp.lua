vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	callback = function()
		vim.pack.add({
			"https://github.com/neovim/nvim-lspconfig",
			"https://github.com/mfussenegger/nvim-lint",
			"https://github.com/stevearc/conform.nvim",
			"https://github.com/nvim-lua/plenary.nvim",
		})
		local set = vim.keymap.set

		local servers = {
			clangd = {},
			gopls = {},
			emmylua_ls = { settings = { Lua = { completion = { callSnippet = true } } } },
			svelte = {},
			marksman = {},
			rust_analyzer = {},
			zls = {},
			tinymist = {},
			ruff = {},
			ty = {},
			tsgo = {},
		}

		local linters_by_ft = {
			go = { "golangcilint" },
		}

		local formatters_by_ft = {
			nix = { "alejandra" },
			typst = { "typstyle" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			js = { "prettier" },
			ts = { "prettier" },
			json = { "prettier" },
			lua = { "stylua" },
		}

		require("lint").linters_by_ft = linters_by_ft
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})

		require("conform").setup({
			formatters_by_ft = formatters_by_ft,
			default_format_opts = { lsp_format = "fallback" },
		})

		set("n", "<leader>w", require("conform").format)

		local on_attach = function(_, bufnr)
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			local fzf = require("fzf-lua")

			set("n", "gD", vim.lsp.buf.declaration, bufopts)
			set("n", "gd", vim.lsp.buf.definition, bufopts)
			set("n", "grr", fzf.lsp_references, bufopts)
		end

		for server, config in pairs(servers) do
			config.on_attach = on_attach
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end

		vim.diagnostic.config({
			virtual_text = true,
		})
	end,
})
