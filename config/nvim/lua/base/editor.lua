local opt = vim.opt

--misc
opt.syntax = "enable"
opt.ignorecase = true
opt.smartcase = true
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

-- disable auto comment
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

--ui
opt.relativenumber = true
opt.number = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.laststatus = 2
opt.wrap = true
opt.showbreak = "󱞶"

-- colors
opt.termguicolors = true

-- create dir if not exists
vim.cmd([[
    au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif
]])

-- highlights yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 100,
		})
	end,
})
