return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            { 'L3MON4D3/LuaSnip', version = "*", build = "make install_jsregexp" },
            'rafamadriz/friendly-snippets',
            'saadparwaiz1/cmp_luasnip',

        },
        config = function()
            local luasnip = require('luasnip')
            require("luasnip.loaders.from_vscode").lazy_load()

            local cmp = require('cmp')
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')

            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()

            )

            cmp.setup({
                performance = {
                    max_view_entries = 10,
                },
                experimental = {
                    ghost_text = true,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                view = {
                    entries = {
                        name = 'custom',
                    }
                },
                formatting = {
                    fields = {
                        "abbr",
                        "kind",
                    }
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<C-l>'] = cmp.mapping(function(_) luasnip.jump(1) end, { 's', 'i' }),
                    ['<C-j>'] = cmp.mapping(function(_) luasnip.jump(-1) end, { 's', 'i' }),
                    ['<C-k>'] = cmp.mapping(function(_) luasnip.expand() end, { 'i' }),
                }),
                sources = cmp.config.sources({
                        { name = 'nvim_lsp' },
                        { name = 'luasnip', option = { show_autosnippets = true } },
                        { name = 'path' }
                    },
                    {
                        { name = 'buffer' },
                    })
            })
            cmp.setup.cmdline({ '/', '?' }, {
                view = {
                    entries = {
                        name = 'custom',
                    }
                },
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                performance = {
                    max_view_entries = 100,
                },
                view = {
                    entries = {
                        name = 'custom',
                    }
                },
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                }),
                matching = { disallow_symbol_nonprefix_matching = false }
            })
        end,
    }
}
