vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mfussenegger/nvim-lint",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
})

local servers = { "clangd", "gopls", "rust_analyzer", "tinymist", "ruff", "ty", "ts_ls" }

local linters_by_ft = {
	go = { "golangcilint" },
}

local conform_opts = {
	formatters_by_ft = {
		nix   = { "nixfmt" },
		typst = { "typstyle" },
		c     = { "clang_format" },
		cpp   = { "clang_format" },
		js    = { "prettier" },
		ts    = { "prettier" },
		json  = { "prettier" },
		yaml  = { "prettier" },
		md    = { "prettier" },
	},
	default_format_opts = { lsp_format = "fallback" },
}

require("lint").linters_by_ft = linters_by_ft

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

require("conform").setup(conform_opts)
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.lsp.enable(servers)

vim.diagnostic.config({
	virtual_text = true,
})
