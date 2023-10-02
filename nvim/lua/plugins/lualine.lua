local ok, lualine = pcall(require, 'lualine')

if not ok then
    return
end

local lsp_status = function()
    return require
end
lualine.setup {
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
        lualine_c = { 'progress' },
        lualine_x = { },
        lualine_y = { 'diff', 'branch' },
        lualine_z = { }
    },
}

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User LspProgressStatusUpdated", {
    group = "lualine_augroup",
    callback = require("lualine").refresh,
})
