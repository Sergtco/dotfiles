-- Fugitive (Git integration)
vim.pack.add({ "https://github.com/tpope/vim-fugitive" })
vim.opt.statusline:append("%{FugitiveStatusline()}")

local set = vim.keymap.set
set("n", "<leader>gg", "<cmd>G<cr>", { desc = "Open fugitive" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "http", "rest" },
	callback = function()
		-- Kulala (HTTP client)
		vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" })
		require("kulala").setup({ global_keymaps = "<leader>R" })

        -- stylua: ignore start
        set("n", "<leader>Rs", function() vim.cmd("Kulala scratchpad") end, { desc = "Send request" })
        set("n", "<leader>Ra", function() vim.cmd("Kulala send_all") end, { desc = "Send all requests" })
        set("n", "<leader>Rb", function() vim.cmd("Kulala scratchpad") end, { desc = "Open scratchpad" })
		-- stylua: ignore end
	end,
})
-- Dadbod (Database client)
vim.pack.add({
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
})

vim.g.db_ui_use_nerd_fonts = 1
vim.cmd([[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]])

set("n", "<leader>gb", "<cmd>DBUIToggle<cr>", { desc = "Toggle database" })
