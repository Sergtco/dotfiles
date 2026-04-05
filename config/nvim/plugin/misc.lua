vim.schedule(function()
    vim.pack.add({
        "https://codeberg.org/andyg/leap.nvim",
        "https://github.com/jake-stewart/multicursor.nvim",
        "https://github.com/kylechui/nvim-surround",
        "https://github.com/windwp/nvim-autopairs",
    })

    require("nvim-surround").setup()
    require("nvim-autopairs").setup()

    
    local set = vim.keymap.set

    set({ "n", "x", "o" }, "s", "<Plug>(leap)")
    set("n", "S", "<Plug>(leap-from-window)")

    local mc = require("multicursor-nvim")
    mc.setup()


    set({ "n", "x" }, "<c-j>", function() mc.lineAddCursor(1) end)
    set({ "n", "x" }, "<c-k>", function() mc.lineAddCursor(-1) end)
    

    set({ "n", "x" }, "<c-n>", function() mc.matchAddCursor(1) end)
    set({ "n", "x" }, "<c-s>", function() mc.matchSkipCursor(1) end)

    set({ "n", "x" }, "<c-q>", mc.toggleCursor)
    set("x", "<C-s>", mc.splitCursors)
    set("n", "<leader>gv", mc.restoreCursors)
    set({ "n", "x" }, "<leader>A", mc.matchAllAddCursors)

    mc.addKeymapLayer(function(layerSet)
        layerSet({ "n", "x" }, "<A-h>", mc.prevCursor)
        layerSet({ "n", "x" }, "<A-l>", mc.nextCursor)
        layerSet({ "n", "x" }, "<A-j>", function() mc.lineSkipCursor(1) end)
        layerSet({ "n", "x" }, "<A-k>", function() mc.lineSkipCursor(-1) end)

        layerSet({ "n", "x" }, "<leader>a", mc.alignCursors)

        layerSet({ "n", "x" }, "<c-x>", mc.deleteCursor)

        layerSet("n", "<esc>", function()
            if not mc.cursorsEnabled() then
                mc.enableCursors()
            else
                mc.clearCursors()
            end
        end)
    end)
end)
