local opt = vim.opt
local g = vim.g


--editor line numbers
opt.number = true
--scrolloff
opt.scrolloff = 5


--signs column
opt.signcolumn = "yes"


--Folding
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
