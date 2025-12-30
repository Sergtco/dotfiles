return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"miroshQa/debugmaster.nvim",
			{ "leoluz/nvim-dap-go", opts = {} },
		},
		keys = {
			{ "<Leader>gg" },
		},
		cmd = {
			"DapContinue",
			"DapNew",
			"DapTerminate",
		},
		config = function()
			local dm = require("debugmaster")
			vim.keymap.set({ "n", "v" }, "<leader>gg", dm.mode.toggle, { nowait = true })
			vim.keymap.set("n", "<Esc>", dm.mode.disable)

			local dap = require("dap")
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
			}

			-- Configs --
			dap.configurations.c = {
				{
					name = "Launch",
					type = "gdb",
					request = "launch",
					program = require("dap.utils").pick_file,
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
				{
					name = "Select and attach to process",
					type = "gdb",
					request = "attach",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					pid = function()
						local name = vim.fn.input("Executable name (filter): ")
						return require("dap.utils").pick_process({ filter = name })
					end,
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.rust = dap.configurations.c
			dap.configurations.cpp = dap.configurations.c
			dap.configurations.zig = dap.configurations.c
		end,
	},
}
