return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "nvimtools/none-ls.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
        local on_attach = function(_, bufnr)
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
            vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, bufopts)
            vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, bufopts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
            vim.keymap.set("n", "<space>w", vim.lsp.buf.format, bufopts)
        end

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        local servers = { 'clangd', 'gopls', 'rust_analyzer', 'basedpyright', 'lua_ls', 'nil_ls', 'ts_ls' }
        for _, server in pairs(servers) do
            if server == 'gopls' then
                require('lspconfig')[server].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {gopls = {gofumpt = true}}
                })
            else
                require('lspconfig')[server].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end
        end

        local signs = {
            { name = "DiagnosticSignError", text = "" },
            { name = "DiagnosticSignWarn", text = "" },
            { name = "DiagnosticSignHint", text = "󰌵" },
            { name = "DiagnosticSignInfo", text = "" },
        }

        for _, sign in ipairs(signs) do
            vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
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
        local config = {
            virtual_text = true,
            update_in_insert = true,
            underline = true,
            signs = {
                active = signs,
            },
            severity_sort = true,
            float = {
                focusable = true,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        }
        vim.diagnostic.config(config)
    end,
}
