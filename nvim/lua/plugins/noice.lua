require("noice").setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
        progress = { enabled = false, view = 'mini' },
        hover = { enabled = false },
        signature = { enabled = false },
    },
    routes = {
        {
            view = "popup",
            filter = {find = "Code actions"}
        },
        {
            view = "mini",
            filter = {
                any = {
                    {find = "change"},
                    {find = "less"},
                    {find = "more"},
                }
            }
        },

    },
    presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
    },
})

require("notify").setup {
    stages = 'fade_in_slide_out',
    background_colour = 'FloatShadow',
    timeout = 3000,
}
