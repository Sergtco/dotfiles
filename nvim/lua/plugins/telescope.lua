return {
    "nvim-telescope/telescope.nvim",
    version = "*",
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>",           desc = "find_files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",            desc = "live_grep" },
        { "<leader>b",  "<cmd>Telescope buffers<cr>",              desc = "buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",            desc = "help_tags" },
        { "<leader>d",  "<cmd>Telescope diagnostics<cr>",          desc = "diagnostics" },
        { "<leader>s",  "<cmd>Telescope lsp_document_symbols<cr>", desc = "lsp_document_symbols" },

    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "CFLAGS=-march=native make" },
    },
    config = function()
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("grapple")
        require("telescope").setup({
            defaults = {
                layout_strategy = 'bottom_pane',
                layout_config = {
                    vertical = {
                    },
                },
            },
            pickers = {
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        })
    end,
}
