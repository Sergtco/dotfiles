return {
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = true,
    },
    {
        "numToStr/Comment.nvim",
        opts = {},
        lazy = false,
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        disabled = true,
        opts = {},
        config = true,
    },
    {
        'notomo/cmdbuf.nvim',
        lasy = false,
        config = function()
            vim.keymap.set("n", "q:", function()
                require("cmdbuf").split_open(vim.o.cmdwinheight)
            end)
        end
    },
}
