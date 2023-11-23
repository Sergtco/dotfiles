local opt = vim.opt
local g = vim.g


--editor line numbers
opt.number = true
--scrolloff
opt.scrolloff = 6


--signs column
opt.signcolumn = "yes"

--scrolloff
opt.scrolloff = 8

--no mode for cmdline
opt.smd = false
--persistent undo
opt.undofile = true

--Folding
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.cmd [[
    augroup remember_folds
      autocmd!
      autocmd BufWinLeave *.* mkview
      autocmd BufWinEnter *.* silent! loadview
    augroup END
]]
