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
    use { 'nvim-treesitter/nvim-treesitter', tag = 'v0.9.1' }
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
        'linrongbin16/lsp-progress.nvim',
    }
    --Jdtls
    use { 'mfussenegger/nvim-jdtls', tag = "0.2.0" }
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
    --telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim', "nvim-lua/popup.nvim" }
    }
    --lualine
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    }
    --wilder
    use 'gelguy/wilder.nvim'

    --toggleterm
    use { "akinsho/toggleterm.nvim", tag = '*' }
    --chatGpt
    use { "jackMort/ChatGPT.nvim", requires = { "MunifTanjim/nui.nvim" } }
    --auotpairs
    use {
        "windwp/nvim-autopairs",
    }
    --comments
    use 'numToStr/Comment.nvim'
    --surrond
    use({
        "kylechui/nvim-surround",
        tag = "*",
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

    if packer_bootstrap then
        require("packer").sync()
    end
end)
