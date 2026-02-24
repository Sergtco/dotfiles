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
			{ "<leader>cc", ":CodeCompanion ", mode = { "n", "v" }, desc = "Inline companion" },
		},
		opts = {
			strategies = {
				chat = {
					adapter = "openrouter",
				},
				inline = {
					adapter = "openrouter",
					keymaps = {
						accept_change = { modes = { n = "<leader>ca" } },
						reject_change = { modes = { n = "<leader>cr" } },
					},
				},
				cmd = {
					adapter = "local",
				},
			},
			opts = {
				log_level = "DEBUG",
			},
			adapters = {
				acp = { opts = { show_presets = false } },
				http = {
					opts = { show_presets = false },
					work = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "work",
							env = {
								url = "https://webui.txix.ru/ollama",
								api_key = "cmd:cat ~/work/ai.key",
							},
							opts = { vision = true, stream = true },
							schema = {
								think = { default = false },
							},
							headers = {
								["Content-Type"] = "application/json",
								["Authorization"] = "Bearer ${api_key}",
							},
							parameters = { sync = true },
						})
					end,
					["openrouter"] = function()
						return require("codecompanion.adapters").extend("openai_compatible", {
							env = {
								url = "https://openrouter.ai/api",
								api_key = "cmd:cat ~/chat/ai.key",
								chat_url = "/v1/chat/completions",
							},
							schema = {
								model = { default = "gpt-oss-120b" },
							},
						})
					end,
					["local"] = function()
						return require("codecompanion.adapters").extend("ollama", {
							name = "local",
							schema = {
								model = { default = "gpt-oss" },
							},
							parameters = { sync = true },
						})
					end,
				},
			},
			display = { chat = { window = { width = 0.3 } } },
		},
	},
}
