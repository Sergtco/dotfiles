return {
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },
    {
        "numToStr/Comment.nvim",
        opts = {},
        lazy = false,
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({ map_bs = false, map_cr = false })
        end
    },
    {
        'notomo/cmdbuf.nvim',
        lasy = false,
        config = function()
            vim.keymap.set("n", "q:", function()
                require("cmdbuf").split_open(vim.o.cmdwinheight)
            end)
        end
    }
}
