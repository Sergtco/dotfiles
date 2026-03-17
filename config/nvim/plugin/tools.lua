vim.pack.add({ 
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/tpope/vim-dadbod",
    "https://github.com/kristijanhusak/vim-dadbod-ui",
    "https://github.com/kristijanhusak/vim-dadbod-completion",
    "https://github.com/mistweaverco/kulala.nvim",
})

vim.opt.statusline:append("%{FugitiveStatusline()}")
vim.keymap.set("n", "<leader>gg", "<cmd>G<cr>", { desc = "Open fugitive" })


vim.g.db_ui_use_nerd_fonts = 1

vim.keymap.set("n", "<leader>gb", "<cmd>DBUIToggle<cr>", { desc = "Toggle database" })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "sql" ,
    callback = function(_)
        vim.cmd([[setlocal omnifunc=vim_dadbod_completion#omni]])
    end,
})


vim.api.nvim_create_autocmd("FileType", {
    pattern = { "http", "rest" },
    callback = function()
        require("kulala").setup({ global_keymaps = "<leader>R" })
    end,
})
