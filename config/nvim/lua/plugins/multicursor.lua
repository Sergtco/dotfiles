return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		local set = vim.keymap.set

        -- stylua: ignore start
        -- Add or skip cursor above/below the main cursor.
        set({"n", "x"}, "<A-k>", function() mc.lineAddCursor(-1) end)
        set({"n", "x"}, "<A-K>", function() mc.lineSkipCursor(-1) end)
        set({"n", "x"}, "<A-j>", function() mc.lineAddCursor(1) end)
        set({"n", "x"}, "<A-J>", function() mc.lineSkipCursor(1) end)

        -- Add or skip adding a new cursor by matching word/selection
        set({"n", "x"}, "<A-n>", function() mc.matchAddCursor(1) end)
        set({"n", "x"}, "<A-N>", function() mc.matchAddCursor(-1) end)
        set({"n", "x"}, "<A-s>", function() mc.matchSkipCursor(1) end)
        set({"n", "x"}, "<A-S>", function() mc.matchSkipCursor(-1) end)

        -- Disable and enable cursors.
        set({"n", "x"}, "<c-q>", mc.toggleCursor)

        mc.addKeymapLayer(function(layerSet)

            -- Select a different cursor as the main one.
            layerSet({"n", "x"}, "<A-h>", mc.prevCursor)
            layerSet({"n", "x"}, "<A-l>", mc.nextCursor)

            layerSet({"n", "x"}, "<leader>a", mc.alignCursors)

            layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

            layerSet("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)
		-- stylua: ignore end

		-- Customize how cursors look.
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { reverse = true })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { link = "CursorColumn" })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}
