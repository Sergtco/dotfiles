local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


require('lazy').setup({
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
            'onsails/lspkind.nvim',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'saadparwaiz1/cmp_luasnip',
            'lukas-reineke/cmp-under-comparator',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp-document-symbol',
            'doxnit/cmp-luasnip-choice',
            'L3MON4D3/LuaSnip',
            {
                'tzachar/cmp-tabnine',
                build = "./install.sh",
            }
        },
        event = 'InsertEnter',
    },
    {
        'folke/tokyonight.nvim'
    },
    --treesitter
    { 'nvim-treesitter/nvim-treesitter' },
    --COQ
    {
        'ms-jpq/coq_nvim',
        branch = 'coq',
        dependencies = {
            {
                'ms-jpq/coq.artifacts', branch = 'artifacts'
            },
            {
                'ms-jpq/coq.thirdparty', branch = '3p'
            },
        }
    },
    -- LSP
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
            "jay-babu/mason-nvim-dap.nvim",
            "neovim/nvim-lspconfig",
            'linrongbin16/lsp-progress.nvim',
        }
    },
    --Jdtls
    { 'mfussenegger/nvim-jdtls',        tag = "0.2.0" },
    --Rust-tools
    'simrat39/rust-tools.nvim',
    -- markdown
    { 'saimo/peek.nvim' },
    --chadtree
    { 'ms-jpq/chadtree', branch = 'chad' },
    --cokeline
    {
        'willothy/nvim-cokeline',
        dependencies = {
            "nvim-lua/plenary.nvim", -- Required for v0.4.0+
            "kyazdani42/nvim-web-devicons", -- If you want devicons
        }
    },
    --telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', "nvim-lua/popup.nvim" }
    },
    --lualine
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons', opt = true },
    },
    --wilder
    'gelguy/wilder.nvim',

    --toggleterm
    { "akinsho/toggleterm.nvim", version = '*' },
    --chatGpt
    {
        "jackMort/ChatGPT.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" }
    },
    --auotpairs
    {
        "windwp/nvim-autopairs",
    },
    --comments
    'numToStr/Comment.nvim',
    --surrond
    {
        "kylechui/nvim-surround",
        version = "*",
    },

    --indent blankline
    "lukas-reineke/indent-blankline.nvim",

    --greeter	
    {
        'goolord/alpha-nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
    },
})
