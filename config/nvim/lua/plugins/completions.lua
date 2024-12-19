return {
    {
        'saghen/blink.cmp',
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                dependencies = 'rafamadriz/friendly-snippets',
                version = "v2.*",
                build = "make install_jsregexp",
            },
            'rafamadriz/friendly-snippets',
        },

        build = 'nix run .#build-plugin',
        opts = {
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            completion = {
                trigger = {
                    prefetch_on_insert = true,
                },
                accept = { auto_brackets = { enabled = true } },
                documentation = {
                    auto_show = true,
                },
                ghost_text = { enabled = true },
            },

            signature = { enabled = true },
            snippets = {
                expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
            },

            keymap = {
                preset = 'default',
                ['<Tab>'] = {},
                ['<S-Tab>'] = {},
            }
        },
        opts_extend = { "sources.default" },
        config = function(_, opts)
            require('blink.cmp').setup(opts)
            require("luasnip.loaders.from_vscode").lazy_load()

            local ls = require("luasnip")

            vim.keymap.set("i", "<C-K>", ls.expand, { desc = "Expand(accept) snippet" })
            vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end,
                { desc = "Jump to next snipeet placeholder" })
            vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end,
                { desc = "Jump to previous snippet placeholder"})
        end
    },
}
