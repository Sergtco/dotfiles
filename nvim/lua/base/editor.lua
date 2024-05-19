local opt = vim.opt
local g = vim.g

--misc
opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
opt.syntax = "enable"
opt.ignorecase = true
opt.smartcase = true
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- file system
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
opt.swapfile = false
opt.backup = false

--indent
local indent = 4
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.softtabstop = indent
opt.tabstop = indent
opt.shiftround = true

--ui
opt.number = true
opt.relativenumber = true
opt.signcolumn = "number"
opt.scrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.laststatus = 3
opt.showbreak = "󱞶"

--colors
opt.termguicolors = true
