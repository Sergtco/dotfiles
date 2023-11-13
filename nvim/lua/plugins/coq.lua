vim.g.coq_settings = {
    auto_start = "shut-up",
    keymap = {
        recommended = false
    },
    clients = {
        lsp = {
            enabled = true,
            weight_adjust = 1.4,
        },
        tree_sitter = {
            enabled = true,
            weight_adjust = 1
        },
        tabnine = {
            enabled = true,
            weight_adjust = 0.8
        },
        snippets = {
            weight_adjust = 1.2
        },
    },
    display = {
        ghost_text = {
            context = { "", "" },
        },
        pum = {
            y_max_len = 10,
        },
        preview = {
            border = "rounded"
        },
    }
}
