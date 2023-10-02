vim.g.coq_settings = {
    auto_start = "shut-up",
    keymap = {
        recommended = false
    },
    clients = {
        lsp = {
            enabled = true,
            weight_adjust = 3,
        },
        tree_sitter = {
            enabled = true,
            weight_adjust = 1
        },
        tabnine = {
            enabled = false,
        },
        snippets = {
            weight_adjust = 2
        },
    },
    display = {
        preview = {
            border = "rounded"
        },
    }
}
