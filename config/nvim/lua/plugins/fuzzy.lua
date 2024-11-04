return {
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>z", "<cmd>FzfLua<cr>",                       desc = "find_files" },
            { "<leader>f", "<cmd>FzfLua files<cr>",                 desc = "find_files" },
            { "<leader>g", "<cmd>FzfLua live_grep<cr>",             desc = "live_grep" },
            { "<leader>b", "<cmd>FzfLua buffers<cr>",               desc = "buffers" },
            { "<leader>d", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "workspace diagnostics" },
            { "<leader>s", "<cmd>FzfLua treesitter<cr>",            desc = "lsp_document_symbols" },

        },
        config = function()
            -- calling `setup` is optional for customization
            require("fzf-lua").setup({
                fzf_colors = true,
                fzf_opts = {
                    ['--layout'] = 'reverse-list'
                },
                winopts = { row = 1, height = 0.5, width = 0.9 },
                previewers = {
                    builtin = {
                        extensions = {
                            ["jpg"] = {"ueberzug"},
                            ["png"] = {"ueberzug"},
                            ["jpeg"] = {"ueberzug"},
                            ["gif"] = {"ueberzug"},
                            ["webp"] = {"ueberzug"},
                        }
                    }
                },
            })
        end
    },
}
