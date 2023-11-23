-- Добавляем Packer как пакет в Neovim
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Используем данный коллбэк как список для плагинов
return require('packer').startup(function(use)
    -- Packer	
    use 'wbthomason/packer.nvim'

    --treesitter
    use { 'nvim-treesitter/nvim-treesitter' }
    --COQ
    use {
        'ms-jpq/coq_nvim', branch = 'coq'
    }
    use {
        'ms-jpq/coq.artifacts', branch = 'artifacts'
    }
    use {
        'ms-jpq/coq.thirdparty', branch = '3p'
    }
    -- LSP
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        "jay-babu/mason-nvim-dap.nvim",
        "neovim/nvim-lspconfig",
        "lukas-reineke/lsp-format.nvim",
        'linrongbin16/lsp-progress.nvim',
    }
    --LspStatus
    use { 'nvim-lua/lsp-status.nvim' }
    --Jdtls
    use 'mfussenegger/nvim-jdtls'
    --Rust-tools
    use 'simrat39/rust-tools.nvim'
    -- markdown
    use({ 'saimo/peek.nvim', run = 'deno task --quiet build:fast' })
    --chadtree
    use { 'ms-jpq/chadtree', branch = 'chad' }

    --cokeline
    use({
        'willothy/nvim-cokeline',
        requires = {
            "nvim-lua/plenary.nvim",        -- Required for v0.4.0+
            "kyazdani42/nvim-web-devicons", -- If you want devicons
        }
    })
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim', "nvim-lua/popup.nvim" }
    }
    --lualine
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    }
    --chatgpt
    use {"Sergtco/ChatGPT.nvim"}

    --toggleterm
    use { "akinsho/toggleterm.nvim", tag = '*' }
    --auotpairs
    use {
        "windwp/nvim-autopairs",
    }
    --comments
    use 'numToStr/Comment.nvim'
    --surrond
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    })

    --indent blankline
    use "lukas-reineke/indent-blankline.nvim"

    --tokyonight
    use 'folke/tokyonight.nvim'
    --greeter	
    use {
        'goolord/alpha-nvim',
        requires = { 'nvim-tree/nvim-web-devicons' },
    }
    --autosave
    use { "Pocco81/auto-save.nvim", }
    --notify
    use { "folke/noice.nvim",
        requires = { "MunifTanjim/nui.nvim", 'rcarriga/nvim-notify' },
    }
    --ZenMode
    use "folke/zen-mode.nvim"
    if packer_bootstrap then
        require("packer").sync()
    end
end)
