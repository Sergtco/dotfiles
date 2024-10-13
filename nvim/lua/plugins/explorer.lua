return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        keys = {
            { "<leader>fe", "<cmd>Oil<cr>", desc = "Open Oil" }
        },
        opts = {},
        -- Optional dependencies
        config = function()
            require('oil').setup({
                columns = {
                    "permissions",
                    "size",
                },
                win_options = {
                    list = true,
                },
                view_options = {
                    show_hidden = true,
                },
                float = {
                    border = "none"
                },
            })
        end
    },
}
