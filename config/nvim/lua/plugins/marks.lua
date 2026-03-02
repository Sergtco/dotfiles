return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>m" },
			{ "<C-h>" },
			{ "<leader>j" },
			{ "<leader>k" },
			{ "<leader>l" },
			{ "<leader>;" },
			{ "<leader>J" },
			{ "<leader>K" },
			{ "<leader>L" },
			{ "[h" },
			{ "]h" },
		},
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({
				settings = {
					sync_on_ui_close = true,
					save_on_toggle = true,
				},
			})
			local set = vim.keymap.set
            -- stylua: ignore start
            set("n", "<leader>m", function() harpoon:list():add() end)
            set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            set("n", "<leader>j", function() harpoon:list():select(1) end)
            set("n", "<leader>k", function() harpoon:list():select(2) end)
            set("n", "<leader>l", function() harpoon:list():select(3) end)
            set("n", "<leader>;", function() harpoon:list():select(4) end)
            set("n", "<leader>J", function() harpoon:list():select(5) end)
            set("n", "<leader>K", function() harpoon:list():select(6) end)
            set("n", "<leader>L", function() harpoon:list():select(7) end)

            set("n", "[h", function() harpoon:list():prev() end)
            set("n", "]h", function() harpoon:list():next() end)
			-- stylua: ignore end
		end,
	},
}
