local ok, alpha = pcall(require, 'alpha')
if not ok then
    return
end

local dashboard = require('alpha.themes.dashboard')
dashboard.section.header.val = {
    "                      ",
    " ▄ .▄      ▄▄▌   ▄▄▄· ",
    "██▪▐█ ▄█▀▄ ██•  ▐█ ▀█ ",
    "██▀▀█▐█▌.▐▌██ ▪ ▄█▀▀█ ",
    "██▌▐▀▐█▌.▐▌▐█▌ ▄▐█▪ ▐▌",
    "▀▀▀ · ▀█▄▀▪.▀▀▀  ▀  ▀ ",
    "                      ",
}


dashboard.section.buttons.val = {
    dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("b", "  > Browse files", ":CHADopen <CR>"),
    dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
    dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
    dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}

local handle = io.popen('fortune')
local fortune = handle and handle:read("*a")
if handle then
    handle:close()
else
    fortune = 'No fortune today'
end
dashboard.section.footer.val = fortune

dashboard.config.opts.noautocmd = true

alpha.setup(dashboard.opts)
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
