return {
    {
        'kylechui/nvim-surround',
        version = '*',
        event = 'VeryLazy',
        config = true,
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        disabled = true,
        opts = {},
        config = true,
    },

    {
        'stevearc/quicker.nvim',
        opts = {},
        config = true,
    },
    {
        'echasnovski/mini-git',
        version = '*',
        main = 'mini.git',
        opts = {},
        config = true,
    },
    {
        'smoka7/hop.nvim',
        version = "*",
        keys = {
            { "ga", "<cmd>HopWord<cr>", desc = "Hop any word" },
        },
        opts = {
            keys = 'etovxqpdygfblzhckisuran'
        }
    }
}
