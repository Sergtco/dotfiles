return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"igorlfs/nvim-dap-view",
				opts = {
					windows = { terminal = { hide = { "go", "rust" } } },
				},
			},
			{ "leoluz/nvim-dap-go", opts = {} },
		},
		config = function()
			local dap = require("dap")
			local dv = require("dap-view")
			-- Adapters --
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

			-- Keymaps --
			vim.keymap.set("n", "<leader>gn", function()
				dap.step_over()
			end)
			vim.keymap.set("n", "<leader>gi", function()
				dap.step_into()
			end)
			vim.keymap.set("n", "<leader>go", function()
				dap.step_out()
			end)

			vim.keymap.set("n", "<Leader>gb", function()
				dap.toggle_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>gl", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end)
			vim.keymap.set("n", "<Leader>gw", function()
				dv.add_expr()
			end)

			vim.keymap.set("n", "<leader>grr", function()
				dap.continue()
			end)
			vim.keymap.set("n", "<Leader>grl", function()
				dap.run_last()
			end)

			dap.listeners.before.attach["dap-view-config"] = function()
				dv.open()
			end
			dap.listeners.before.launch["dap-view-config"] = function()
				dv.open()
			end
			dap.listeners.before.event_terminated["dap-view-config"] = function()
				dv.close()
			end
			dap.listeners.before.event_exited["dap-view-config"] = function()
				dv.close()
			end
		end,
	},
}
