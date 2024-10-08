return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "vim", "vimdoc", "query", "comment", "markdown", "markdown_inline" },
			sync_install = true,
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max_filesize = 100 * 1024
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = { "ruby", "markdown" },
			},
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
