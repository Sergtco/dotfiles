return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"igorlfs/nvim-dap-view",
			{
				"leoluz/nvim-dap-go",
				opts = {},
			},
		},
		keys = {
            -- stylua: ignore start
			{ "<C-n>", function() require("dap").step_over() end },
			{ "<A-i>", function() require("dap").step_into() end },
			{ "<A-o>", function() require("dap").step_out() end },
			{ "<C-t>", function() require("dap").toggle_breakpoint() end },
			{ "<Leader>gw", function() require("dap-view").add_expr() end },
			{ "<leader>gc", function() require("dap").continue() end },
			-- stylua: ignore end
		},
		cmd = {
			"DapViewOpen",
			"DapContinue",
			"DapNew",
			"DapTerminate",
		},
		config = function()
			local dap = require("dap")
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
			}

			dap.adapters["rust-gdb"] = vim.tbl_deep_extend("force", dap.adapters.gdb, { command = "rust-gdb" })
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
			dap.configurations.cpp = dap.configurations.c
			dap.configurations.zig = dap.configurations.c
			dap.configurations.rust =
				vim.tbl_deep_extend("force", dap.configurations.c, { { type = "rust-gdb" }, { type = "rust-gdb" } })

			local dv = require("dap-view")

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
