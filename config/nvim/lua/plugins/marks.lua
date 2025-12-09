local function edit(path)
	path = string.gsub(path, "#", "\\#")
	vim.cmd.edit(path)
end
return {
	{
		"cbochs/grapple.nvim",
		keys = {
			{ "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle" },
			{ "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags" },
			{ "<leader>j", "<cmd>Grapple select index=1<cr>", desc = "Grapple select index=1" },
			{ "<leader>k", "<cmd>Grapple select index=2<cr>", desc = "Grapple select index=2" },
			{ "<leader>l", "<cmd>Grapple select index=3<cr>", desc = "Grapple select index=3" },
			{ "<leader>;", "<cmd>Grapple select index=4<cr>", desc = "Grapple select index=4" },
			{ "<leader>J", "<cmd>Grapple select index=5<cr>", desc = "Grapple select index=5" },
			{ "<leader>K", "<cmd>Grapple select index=6<cr>", desc = "Grapple select index=6" },
			{ "<leader>L", "<cmd>Grapple select index=7<cr>", desc = "Grapple select index=7" },
			{ "[m", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle_tags prev" },
			{ "]m", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle_tags next" },
		},
		opts = {
			icons = false,
			command = edit,
		},
	},
}
