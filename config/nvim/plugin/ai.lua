vim.schedule(function()
	vim.pack.add({
		"https://github.com/olimorris/codecompanion.nvim",
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/nvim-treesitter/nvim-treesitter",
	})
	require("codecompanion").setup({
		strategies = {
			chat = {
				adapter = "openrouter",
			},
			inline = {
				adapter = "openrouter",
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
	})

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
end)
