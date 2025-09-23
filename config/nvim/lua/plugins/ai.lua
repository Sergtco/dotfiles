return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = {
			"CodeCompanion",
			"CodeCompanionChat",
			"CodeCompanionActions",
			"CodeCompanionCmd",
		},
		keys = {
			{ "<leader>ct", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Open ai chat" },
			{ "<leader>cy", "<cmd>CodeCompanionChat Add<CR>", mode = { "n", "v" }, desc = "Open ai chat" },
			{ "<leader>cc", "<cmd>CodeCompanion<CR>", mode = { "n", "v" }, desc = "Inline companion" },
		},
		opts = {
			strategies = {
				chat = {
					adapter = "qwen3",
				},
				inline = {
					adapter = "qwen3",
					keymaps = {
						accept_change = { modes = { n = "<leader>ca" } },
						reject_change = { modes = { n = "<leader>cr" } },
					},
				},
				cmd = {
					adapter = "qwen3",

				},
			},
			opts = {
				log_level = "DEBUG",
			},
			adapters = {
				http = {
					qwen3 = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "qwen3",
							opts = {
								vision = true,
								stream = true,
							},
							schema = {
								model = {
									default = "qwen3:8b",
								},
								think = {
									default = false,
								},
							},
						})
					end,
				},
			},
		},
		config = function(_, opts)
			require("codecompanion").setup(opts)
		end,
	},
}
