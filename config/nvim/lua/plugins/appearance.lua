return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("kanagawa-wave")
		end,
		opts = {
			compile = true,
			overrides = function(colors)
				local theme = colors.theme
				return {
					NormalFloat = { bg = theme.ui.bg_p1 },
					FloatBorder = { fg = "none", bg = "none" },
					FloatTitle = { bg = "none" },
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
					PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },
					LineNr = { bg = "none" },
					SignColumn = { bg = "none" },
					DiagnosticSign = { bg = "none" },
					FzfLuaNormal = { bg = theme.ui.bg_dim },
					FzfLuaBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
				}
			end,
		},
	},
}
