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
					adapter = "openrouter",
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
								model = { default = "xiaomi/mimo-v2-flash" },
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
			interactions = { chat = { opts = { completion_provider = "default" } } },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "codecompanion",
				callback = function()
					vim.api.nvim_create_autocmd("InsertCharPre", {
						callback = function()
							local char = vim.v.char
							if char == "/" or char == "@" or char == "#" then
								vim.api.nvim_feedkeys(
									vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true),
									"i",
									false
								)
							end
						end,
					})
					vim.cmd([[setlocal complete=o,.,w,b,u]])
				end,
			})
		end,
	},
}
