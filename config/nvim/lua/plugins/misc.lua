return {
    {
        'kylechui/nvim-surround',
        version = '*',
        event = 'VeryLazy',
        config = true,
    },
    {
        'numToStr/Comment.nvim',
        opts = {},
        lazy = false,
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        disabled = true,
        opts = {},
        config = true,
    },
}
