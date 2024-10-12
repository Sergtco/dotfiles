return {
    "williamboman/mason.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason-lspconfig.nvim",
        "stevearc/conform.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup()

        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
        local on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            ---keymaps
            require("keys/plugins").lsp(client, bufnr)
        end

        require("conform").setup({
            formatters_by_ft = {
                python = { "ruff" },
            },
            format_on_save = true,
            {
                lsp_fallback = true,
                timeout_ms = 500,
            },
            formatters = {
                gopls = {
                    command = "ya tool gofmt"
                },
            }
        })

        vim.filetype.add({ extension = { templ = "templ" } })

        require("mason-lspconfig").setup_handlers({
            function(server_name)
                require("lspconfig")[server_name].setup({
                    on_attach = on_attach,
                })
            end,
            ["basedpyright"] = function()
                local filepath = vim.fn.expand("%:p")
                if string.find(filepath, "arcadia") ~= nil then
                    require('lspconfig').basedpyright.setup({
                        on_attach = on_attach,
                        settings = {
                            basedpyright = {
                                analysis = {
                                    typeCheckingMode = "standard",
                                    diagnosticSeverityOverrides = {
                                        reportImplicitRelativeImport = false,
                                    }
                                }
                            },
                            python = {
                                pythonPath = "/usr/local/bin/python3.7"
                            }

                        }
                    })
                else
                    require('lspconfig').basedpyright.setup({
                        on_attach = on_attach,
                    })
                end
            end,
            ["gopls"] = function()
                local filepath = vim.fn.expand("%:p")
                if string.find(filepath, "arcadia") ~= nil then
                    require 'lspconfig'.gopls.setup({
                        on_attach = on_attach,
                        cmd = { "ya", "tool", "gopls" },
                        -- root_dir = require("lspconfig.util").root_pattern("ya.make", "go.work", "go.mod", ".git"),
                        settings = {
                            gopls = {
                                directoryFilters = {
                                    "-",
                                    "+taxi/backend-go/",
                                    "-library/",
                                    "+library/go"
                                }
                            }
                        }
                    })
                else
                    require 'lspconfig'.gopls.setup({
                        on_attach = on_attach,
                    })
                end
            end
        })

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
            virtual_text = false,
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
