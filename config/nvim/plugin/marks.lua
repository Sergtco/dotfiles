vim.schedule(function()
	vim.pack.add({
		{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
		"https://github.com/nvim-lua/plenary.nvim",
	})

	local harpoon = require("harpoon")
	harpoon:setup({
		settings = {
			sync_on_ui_close = true,
			save_on_toggle = true,
		},
	})

	local set = vim.keymap.set
    -- stylua: ignore start
    set("n", "<leader>m", function() harpoon:list():add() end, { desc = "Harpoon add" })
    set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon toggle menu" })

    set("n", "<leader>j", function() harpoon:list():select(1) end, { desc = "Harpoon select 1" })
    set("n", "<leader>k", function() harpoon:list():select(2) end, { desc = "Harpoon select 2" })
    set("n", "<leader>l", function() harpoon:list():select(3) end, { desc = "Harpoon select 3" })
    set("n", "<leader>;", function() harpoon:list():select(4) end, { desc = "Harpoon select 4" })
    set("n", "<leader>J", function() harpoon:list():select(5) end, { desc = "Harpoon select 5" })
    set("n", "<leader>K", function() harpoon:list():select(6) end, { desc = "Harpoon select 6" })
    set("n", "<leader>L", function() harpoon:list():select(7) end, { desc = "Harpoon select 7" })

    set("n", "[h", function() harpoon:list():prev() end, { desc = "Harpoon prev" })
    set("n", "]h", function() harpoon:list():next() end, { desc = "Harpoon next" })
	-- stylua: ignore end
end)
