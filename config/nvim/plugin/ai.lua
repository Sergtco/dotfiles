vim.schedule(function()
	vim.pack.add({
		"https://github.com/olimorris/codecompanion.nvim",
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/nvim-treesitter/nvim-treesitter",
	})
	require("codecompanion").setup({
		strategies = {
			chat = { adapter = "openrouter", },
			inline = { adapter = "openrouter", },
			cmd = { adapter = "openrouter", },
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

	local set = vim.keymap.set
	set("n", "<leader>ct", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Open ai chat" })
	set({ "n", "v" }, "<leader>cy", "<cmd>CodeCompanionChat Add<CR>", { desc = "Open ai chat" })
	set({ "n", "v" }, "<leader>cc", ":CodeCompanion ", { desc = "Inline companion" })
end)
