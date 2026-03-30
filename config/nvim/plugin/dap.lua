vim.schedule(function()
	vim.pack.add({
		"https://github.com/mfussenegger/nvim-dap",
		"https://github.com/igorlfs/nvim-dap-view",
		"https://github.com/leoluz/nvim-dap-go",
	})

    require("dap-go").setup()
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

	local set = vim.keymap.set
    -- stylua: ignore start
    set("n", "<A-n>", function() require("dap").step_over() end, { desc = "DAP step over" })
    set("n", "<A-i>", function() require("dap").step_into() end, { desc = "DAP step into" })
    set("n", "<A-o>", function() require("dap").step_out() end, { desc = "DAP step out" })
    set("n", "<leader>gb", function() require("dap").toggle_breakpoint() end, { desc = "DAP toggle breakpoint" })
    set("n", "<Leader>gw", function() require("dap-view").add_expr() end, { desc = "DAP view add expression" })
	-- stylua: ignore end
end)
