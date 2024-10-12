return {
    "cbochs/grapple.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    keys = {
        { "<leader>m", "<cmd>Grapple toggle<cr>", desc="Grapple toggle" },
        { "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc="Grapple select index=1" },
        { "<leader>j", "<cmd>Grapple select index=1<cr>", },
        { "<leader>k", "<cmd>Grapple select index=2<cr>" },
        { "<leader>l", "<cmd>Grapple select index=3<cr>" },
        { "<leader>;", "<cmd>Grapple select index=4<cr>" },
        { "<leader>[", "<cmd>Grapple cycle_tags prev<cr>" },
        { "<leader>]", "<cmd>Grapple cycle_tags next<cr>" },
    },
    config = function()
        require("grapple").setup({
            scope = "git_branch",
            icons = true,
        })
    end,
}
