vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		vim.pack.add({
			"https://github.com/nvim-mini/mini.completion",
			"https://github.com/rafamadriz/friendly-snippets",
			"https://github.com/nvim-mini/mini.snippets",
		})

		require("mini.completion").setup({ lsp_completion = { source_func = "omnifunc", auto_setup = false } })

		local gen_loader = require("mini.snippets").gen_loader
		require("mini.snippets").setup({
			snippets = {
				gen_loader.from_runtime("global.json"),
				gen_loader.from_lang(),
			},
		})

		vim.keymap.set("i", "<CR>", function()
			if vim.fn.pumvisible() == 1 then
				return "<C-e><CR>"
			else
				if pcall(require, "mini.pairs") == false then
					return "<CR>"
				end
				return require("mini.pairs").cr()
			end
		end, { expr = true, noremap = true })
	end,
})
