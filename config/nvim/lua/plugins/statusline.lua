return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require('lualine').setup({
                options = {
                    section_separators = "",
                    component_separators = "|",
                },
                extensions = { "oil", "lazy", "quickfix", "fzf" },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "filename" },
                    lualine_c = { "diagnostics" },
                    lualine_x = {},
                    lualine_y = { "diff" },
                    lualine_z = { "branch" },
                },
            })
        end,
    }
}
