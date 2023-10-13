require ('mason-nvim-dap').setup({
    ensure_installed = {},
    handlers = {
        function(config)
          -- all sources with no handler get passed here

          -- Keep original functionality
          require('mason-nvim-dap').default_setup(config)
        end,
        python = function(config)
            config.adapters = {
	            type = "executable",
	            command = "/home/sergtco/.local/share/nvim/mason/bin/debugpy-adapter",
	            args = {
	            },
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
        end,
        rust = function(config)
        end,
    },
})
require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
