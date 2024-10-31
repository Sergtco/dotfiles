local opt = vim.opt

--misc
opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
opt.syntax = "enable"
opt.ignorecase = true
opt.smartcase = true
opt.colorcolumn = "80"
opt.shortmess:append("I")

-- file system
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.swapfile = false
opt.backup = false

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

opt.guicursor = 'n-c:block,v:hor25,i-ci-ve:ver25,r-cr:hor20,o:hor50'

--colors
opt.termguicolors = true