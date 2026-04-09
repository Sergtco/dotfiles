vim.schedule(function()
	vim.pack.add({
        "https://github.com/sudo-tee/opencode.nvim",
        "https://github.com/nvim-lua/plenary.nvim",
	})
    require("opencode").setup({
        keymap = {
            input_window = {
                ['<esc>'] = false,
            }
        }
    })
end)
