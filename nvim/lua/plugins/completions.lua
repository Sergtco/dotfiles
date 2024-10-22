return {
    -- {
    --     "hrsh7th/nvim-cmp",
    --
    --     dependencies = {
    --         "hrsh7th/cmp-nvim-lsp",
    --         {
    --             "saadparwaiz1/cmp_luasnip",
    --             build = "make install_jsregexp",
    --         },
    --         "L3MON4D3/LuaSnip",
    --         'andersevenrud/cmp-tmux',
    --         "hrsh7th/cmp-buffer",
    --         "hrsh7th/cmp-nvim-lsp-document-symbol",
    --         "onsails/lspkind.nvim",
    --         "hrsh7th/cmp-cmdline",
    --         "hrsh7th/cmp-path",
    --         "rafamadriz/friendly-snippets",
    --     },
    --     disabled = true,
    --     config = function()
    --         local cmp = require("cmp")
    --         local luasnip = require("luasnip")
    --         local lspkind = require("lspkind")
    --         -- If you want insert `(` after select function or method item
    --         local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    --         cmp.event:on(
    --             'confirm_done',
    --             cmp_autopairs.on_confirm_done()
    --         )
    --         require("luasnip.loaders.from_vscode").lazy_load()
    --         cmp.setup({
    --             view = {
    --                 entries = "custom",
    --             },
    --             window = {
    --                 completion = {
    --                     winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
    --                     col_offset = -3,
    --                     side_padding = 0,
    --                 }
    --             },
    --             completion = {
    --                 autocomplete = {
    --                     cmp.TriggerEvent.TextChanged,
    --                     cmp.TriggerEvent.InsertEnter,
    --                 },
    --                 completeopt = "menuone,noinsert,noselect",
    --                 keyword_length = 0,
    --             },
    --             formatting = {
    --                 fields = {
    --                     "kind",
    --                     "abbr",
    --                     "menu",
    --                 },
    --
    --                 format = function(entry, vim_item)
    --                     local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50, show_labelDetails = true, })(
    --                         entry, vim_item)
    --                     local strings = vim.split(kind.kind, "%s", { trimempty = true })
    --                     kind.kind = (strings[1] or "")
    --                     kind.menu = " " .. (strings[2] or "")
    --                     return kind
    --                 end,
    --             },
    --             snippet = {
    --                 expand = function(args)
    --                     luasnip.lsp_expand(args.body)
    --                 end,
    --             },
    --             sources = cmp.config.sources({
    --                 { name = "nvim_lsp",  priority = 8 },
    --                 { name = "luasnip",   priority = 6, option = { use_show_condition = true, show_autosnippets = true } },
    --                 { name = "path",      priority = 3 },
    --                 { max_item_count = 10 },
    --                 {
    --                     name = "buffer",
    --                     priority = 2,
    --                     option = {
    --                         get_bufnrs = function()
    --                             return vim.api.nvim_list_bufs()
    --                         end
    --                     }
    --                 }
    --             }),
    --             sorting = {
    --                 comparators = {
    --                     cmp.config.compare.locality,
    --                     cmp.config.compare.recently_used,
    --                     cmp.config.compare.score,
    --                     cmp.config.compare.offset,
    --                     cmp.config.compare.order,
    --                 },
    --             },
    --             mapping = cmp.mapping.preset.insert({
    --                 ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    --                 ["<C-d>"] = cmp.mapping.scroll_docs(4),
    --                 ["<CR>"] = cmp.mapping.confirm({ select = false }),
    --                 ["<C-n>"] = cmp.mapping.select_next_item(),
    --                 ["<C-p>"] = cmp.mapping.select_prev_item(),
    --             }),
    --             experimental = {
    --                 ghost_text = true,
    --             },
    --         })
    --
    --         cmp.setup.cmdline({ "/", "?" }, {
    --             mapping = cmp.mapping.preset.cmdline(),
    --             sources = {
    --                 { name = "nvim_lsp_document_symbol" },
    --                 { name = "buffer" },
    --             }
    --         })
    --
    --         cmp.setup.cmdline(":", {
    --             mapping = cmp.mapping.preset.cmdline(),
    --             sources = cmp.config.sources({
    --                 { name = "path" },
    --                 { name = "cmdline" },
    --             }),
    --         })
    --     end,
    -- },
    -- {
    --     "L3MON4D3/LuaSnip",
    --     version = "*",
    --     config = function()
    --         local ls = require("luasnip")
    --         vim.keymap.set({ "i" }, "<C-k>", function()
    --             ls.expand()
    --         end, { silent = true })
    --         vim.keymap.set({ "i", "s" }, "<C-l>", function()
    --             ls.jump(1)
    --         end, { silent = true })
    --         vim.keymap.set({ "i", "s" }, "<C-j>", function()
    --             ls.jump(-1)
    --         end, { silent = true })
    --
    --         vim.keymap.set({ "i", "s" }, "<C-e>", function()
    --             if ls.choice_active() then
    --                 ls.change_choice(1)
    --             end
    --         end, { silent = true })
    --     end,
    -- },

    {
        "ms-jpq/coq_nvim",
        branch = "coq",
        dependencies = {
            { "ms-jpq/coq.artifacts",  branch = "artifacts" },

            { 'ms-jpq/coq.thirdparty', branch = "3p" }
        },
        init = function()
            vim.g.coq_settings = {
                auto_start = "shut-up",
                keymap = {
                    recommended = false,
                    jump_to_mark = '<c-h>',
                }
            }
            local remap = vim.api.nvim_set_keymap
            local npairs = require('nvim-autopairs')

            -- remap('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
            -- remap('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
            -- remap('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
            -- remap('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

            -- skip it, if you use another global object
            _G.MUtils = {}

            MUtils.CR = function()
                if vim.fn.pumvisible() ~= 0 then
                    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
                        return npairs.esc('<c-y>')
                    else
                        return npairs.esc('<c-e>') .. npairs.autopairs_cr()
                    end
                else
                    return npairs.autopairs_cr()
                end
            end
            remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

            MUtils.BS = function()
                if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
                    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
                else
                    return npairs.autopairs_bs()
                end
            end
            remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })
        end,
    }
}
