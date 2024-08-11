return {
	"williamboman/mason.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"williamboman/mason-lspconfig.nvim",
		"stevearc/conform.nvim",
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()

		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
		local on_attach = function(client, bufnr)
			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
			---keymaps
			require("keys/plugins").lsp(client, bufnr)
		end

		require("conform").setup({
			formatters_by_ft = {
				-- python = {"black" },
			},
			format_on_save = true,
			{
				lsp_fallback = true,
				timeout_ms = 500,
			},
		})

		vim.filetype.add({ extension = { templ = "templ" } })
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- require("lspconfig").gleam.setup({
		-- 	on_attach = on_attach,
		-- 	capabilities = capabilities,
		-- 	settings = {
		-- 		inlay_hints = false,
		-- 	},
		-- })
		require("lspconfig").erlangls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
		require("mason-lspconfig").setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end,
			["clangd"] = function()
				require("lspconfig").clangd.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					settings = {
						clangd = {
							InlayHints = {
								Designators = false,
								Enabled = true,
								ParameterNames = false,
								DeducedTypes = true,
							},
						},
					},
				})
			end,
			["html"] = function()
				require("lspconfig")["html"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
					filetypes = { "html", "templ" },
				})
				require("lspconfig")["emmet_language_server"].setup({
					on_attach = on_attach,
					capabilities = capabilities,
					filetypes = { "html", "templ" },
				})
			end,
		})

		local signs = {
			{ name = "DiagnosticSignError", text = "" },
			{ name = "DiagnosticSignWarn", text = "" },
			{ name = "DiagnosticSignHint", text = "󰌵" },
			{ name = "DiagnosticSignInfo", text = "" },
		}

		for _, sign in ipairs(signs) do
			vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
		end
		local config = {
			virtual_text = false,
			update_in_insert = true,
			underline = true,
			signs = {
				active = signs,
			},
			severity_sort = true,
			float = {
				focusable = true,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		}
		vim.diagnostic.config(config)
	end,
}
