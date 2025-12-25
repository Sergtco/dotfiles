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
					adapter = "work",
				},
				inline = {
					adapter = "work",
					keymaps = {
						accept_change = { modes = { n = "<leader>ca" } },
						reject_change = { modes = { n = "<leader>cr" } },
					},
				},
				cmd = {
					adapter = "work",
				},
			},
			opts = {
				log_level = "DEBUG",
			},
			adapters = {
				acp = { opts = { show_defaults = false } },
				http = {
					opts = { show_defaults = false },
					work = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "work",
							env = {
								url = "https://webui.txix.ru/ollama",
								api_key = "cmd:cat ~/work/ai.key",
							},
							opts = { vision = true, stream = true },
							schema = {
								model = { default = "qwen3:32b" },
								think = { default = false },
							},
							headers = {
								["Content-Type"] = "application/json",
								["Authorization"] = "Bearer ${api_key}",
							},
							parameters = { sync = true },
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
