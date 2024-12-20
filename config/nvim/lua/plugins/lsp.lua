return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "nvimtools/none-ls.nvim",
        "nvim-lua/plenary.nvim",
        "saghen/blink.cmp",
    },

    opts = {
        servers = {
            clangd = {},
            rust_analyzer = {},
            basedpyright = {},
            lua_ls = {},
            nil_ls = {},
            ts_ls = {},
            gopls = { settings = { gopls = { gofumpt = true } } },
        }
    },

    config = function(_, opts)
        local on_attach = function(_, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, bufopts)
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
            vim.keymap.set({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, bufopts)
            vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, bufopts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
            vim.keymap.set("n", "<space>w", vim.lsp.buf.format, bufopts)
        end

        for server, config in pairs(opts.servers) do
            config.on_attach = on_attach
            config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            require('lspconfig')[server].setup(config)
        end

        local null_ls = require('null-ls')
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.alejandra,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.sqlfmt,
                null_ls.builtins.formatting.clang_format,
            },
            on_attach = on_attach,
        })
    end,
}
