return {
    {
        "stevearc/oil.nvim",
        opts = {},
        -- Optional dependencies
        lazy = false,
        keys = {
            {"<leader>fe", "<cmd>Oil<cr>", desc="Open Oil"}
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require('oil').setup({
                columns = {
                    "permissions",
                    "size",
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
