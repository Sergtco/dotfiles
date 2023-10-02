local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')
dashboard.section.header.val = {" ________                   __                                             ", 
"|        \\                 |  \\                                            ", 
"| ▓▓▓▓▓▓▓▓__    __  _______| ▓▓   __                   ", 
"| ▓▓__   |  \\  |  \\/       \\ ▓▓  /  \\                              ", 
"| ▓▓  \\  | ▓▓  | ▓▓  ▓▓▓▓▓▓▓ ▓▓_/  ▓▓    ", 
"| ▓▓▓▓▓  | ▓▓  | ▓▓ ▓▓     | ▓▓   ▓▓         ", 
"| ▓▓     | ▓▓__/ ▓▓ ▓▓_____| ▓▓▓▓▓▓\\           ", 
"| ▓▓      \\▓▓    ▓▓\\▓▓     \\ ▓▓  \\▓▓\\              ", 
" \\▓▓       \\▓▓▓▓▓▓  \\▓▓▓▓▓▓▓\\▓▓   \\▓▓"}




dashboard.section.buttons.val = {
    dashboard.button( "e", "  > New file" , ":ene <BAR> startinsert <CR>"),
    dashboard.button( "b", "  > Browse files", ":CHADopen <CR>"),
    dashboard.button( "f", "  > Find file", ":Telescope find_files<CR>"),
    dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
    dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    dashboard.button( "q", "  > Quit NVIM", ":qa<CR>"),
}
alpha.setup(dashboard.opts)
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])

