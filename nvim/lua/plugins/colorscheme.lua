return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                compile = true,
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        NormalFloat = { bg = theme.ui.bg_p1 },
                        FloatBorder = { fg = "none", bg = "none" },
                        FloatTitle = { bg = "none" },
                        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
                        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },
                        LineNr = { bg = "none" },
                        SignColumn = { bg = "none" },
                        DiagnosticSign = { bg = "none" },
                    }
                end,
            })
            vim.cmd.colorscheme("kanagawa")
        end,
    },
}
