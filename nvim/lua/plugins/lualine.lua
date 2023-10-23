local ok, lualine = pcall(require, 'lualine')

if not ok then
    return
end

function lsp_progress()
    return require("lsp-progress").progress({ max_size = 50 })
end

lualine.setup {
    extensions = { 'chadtree' },
    options = {
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'filename', 'encoding' },
        lualine_c = { 'progress',lsp_progress},
        lualine_x = {},
        lualine_y = { 'diff', 'branch' },
        lualine_z = {}
    },
}

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = require("lualine").refresh,
})
