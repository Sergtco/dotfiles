return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		local set = vim.keymap.set

        -- Add or skip cursor above/below the main cursor.
        -- stylua: ignore start
        set({ "n", "x" }, "<A-S-c>", function() mc.lineAddCursor(-1) end)
        set({ "n", "x" }, "<A-c>", function() mc.lineAddCursor(1) end)

        -- Pressing `gaip` will add a cursor on each line of a paragraph.
        set("n", "ga", mc.addCursorOperator)


        -- Pressing `<leader>miwap` will create a cursor in every match of the
        -- string captured by `iw` inside range `ap`.
        set({ "n", "x" }, "<leader>x", mc.operator)
        -- Add or skip adding a new cursor by matching word/selection
        set({ "n", "x" }, "<c-q>", mc.toggleCursor)
        -- Split visual selections by regex.
        set("x", "S", mc.splitCursors)
        -- match new cursors within visual selections by regex.
        set("x", "M", mc.matchCursors)

        mc.addKeymapLayer(function(layerSet)
            layerSet({ "n", "x" }, "<A-h>", mc.prevCursor)
            layerSet({ "n", "x" }, "<A-l>", mc.nextCursor)

            layerSet({ "n", "x" }, "<A-x>", mc.deleteCursor)

            set("n", "ga", mc.alignCursors)


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
		hl(0, "MultiCursorCursor", { link = "Cursor" })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}
