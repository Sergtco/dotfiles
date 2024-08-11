local opt = vim.opt
local g = vim.g

--misc
opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
opt.syntax = "enable"
opt.ignorecase = true
opt.smartcase = true
opt.colorcolumn = "80"
opt.shortmess:append("I")
opt.runtimepath:append(",/usr/local/bin/fzf")

vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- file system
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.swapfile = false
opt.backup = false
g.netrw_liststyle = 3

--indent
local indent = 4
opt.expandtab = true
opt.shiftwidth = indent
opt.softtabstop = indent
opt.tabstop = indent
opt.shiftround = true

--ui
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.laststatus = 3
opt.wrap = true
opt.showbreak = "󱞶"

--colors
opt.termguicolors = true
