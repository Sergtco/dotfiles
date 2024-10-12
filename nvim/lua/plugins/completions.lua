return {
    {
        "hrsh7th/nvim-cmp",

        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            {
                "saadparwaiz1/cmp_luasnip",
                build = "make install_jsregexp",
            },
            "L3MON4D3/LuaSnip",
            'andersevenrud/cmp-tmux',
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            "onsails/lspkind.nvim",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-path",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            -- If you want insert `(` after select function or method item
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
            require("luasnip.loaders.from_vscode").lazy_load()
            cmp.setup({
                view = {
                    entries = "custom",
                },
                window = {},
                formatting = {
                    fields = {
                        "abbr",
                        "kind",
                    },

                    format = function(entry, vim_item)
                        local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50, symbol_map = {} })(
                            entry, vim_item)
                        local strings = vim.split(kind.kind, "%s", { trimempty = true })
                        kind.kind = " " .. (strings[1] or "") .. " "
                        return kind
                    end,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp",  priority = 8 },
                    { name = "luasnip",   priority = 6, options = { use_show_condition = true } },
                    { name = "path",      priority = 3 },
                    { name = "tmux",      priority = 2, options = { all_panes = true } },
                    { max_item_count = 10 },
                }, {
                    { name = "buffer", priority = 2 },
                }),
                sorting = {
                    comparators = {
                        cmp.config.compare.locality,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.score,
                        cmp.config.compare.offset,
                        cmp.config.compare.order,
                    },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                }),
                experimental = {
                    ghost_text = true,
                },
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "nvim_lsp_document_symbol" },
                    { name = "buffer" },
                }
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline" },
                }),
            })
        end,
    }, {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    config = function()
        local ls = require("luasnip")
        vim.keymap.set({ "i" }, "<C-k>", function()
            ls.expand()
        end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-l>", function()
            ls.jump(1)
        end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<C-j>", function()
            ls.jump(-1)
        end, { silent = true })

        vim.keymap.set({ "i", "s" }, "<C-e>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, { silent = true })
    end,
}
}
