return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
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
            vim.keymap.set("n", "<space>w", function()
                require("conform").format({ bufnr = bufnr, lsp_format = "fallback" })
            end, bufopts)
        end

        require("conform").setup({
            formatters_by_ft = {
                python = { "ruff" },
                go = { "gofumpt" },
            },
            format_on_save = true,
            {
                lsp_fallback = true,
                timeout_ms = 500,
            },
        })

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        local servers = { 'gleam', 'gopls', 'rust_analyzer', 'basedpyright', 'lua_ls', 'nil_ls' }
        for _, server in pairs(servers) do
            require('lspconfig')[server].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
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
