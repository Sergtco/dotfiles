local ok, lualine = pcall(require, 'lualine')

if not ok then
    return
end

local function lsp_progress()
    return require("lsp-progress").progress({ max_size = 75 })
end
local function modes(str)
    if str == "INSERT" then
        return "INS"
    elseif str == "NORMAL" then
        return "NOR"
    elseif str == "VISUAL" then
        return "VIS"
    elseif str == "V-LINE" then
        return "VIS-L"
    elseif str == "COMMAND" then
        return "COM"
    end
    return str
end

lualine.setup {
    extensions = { 'chadtree', 'mason', 'toggleterm' },
    options = {
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = '|',
        section_separators = {},
        disabled_filetypes = { "alpha" },
        always_divide_middle = false,
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
