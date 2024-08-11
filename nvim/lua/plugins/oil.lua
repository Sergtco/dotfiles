return {
	"stevearc/oil.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
        require('oil').setup({
            columns = {
                "icon",
                "size",
            },
            view_options = {
                show_hidden = true,
            },
            float = {
                border = "none"
            },
        })
    end
}
