vim.g.mapleader = " "
require("keys")

local o = vim.opt

o.ignorecase = true
o.smartcase = true

-- diff
o.diffopt:remove("linematch:40")

-- file system
o.undofile = true
o.swapfile = false
o.exrc = true

--indent
local indent = 4
o.expandtab = true
o.shiftround = true
o.shiftwidth = indent
o.softtabstop = indent
o.tabstop = indent

-- fold
vim.wo.foldmethod = "indent"
vim.wo.foldlevel = 99 

--ui
o.relativenumber = true
o.number = true
o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true

-- colors
o.termguicolors = true

-- plugins
vim.cmd("packadd cfilter")
vim.cmd("packadd nvim.undotree")
vim.cmd("packadd nvim.difftool")

-- cmd
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "msg",
		timeout = 3000,
	},
})

-- completions
vim.o.completeopt = "menuone,noselect,fuzzy"
vim.o.pumheight = 10
vim.o.complete = "o,.,w,b,u,t"

vim.api.nvim_create_autocmd("CmdlineChanged", {
	pattern = "[:/\\?]",
	callback = function()
		vim.fn.wildtrigger()
	end,
})
vim.o.wildmode = "noselect:lastused,full"
vim.o.wildoptions = "pum,fuzzy"

-- langmap
local function escape(str)
	local escape_chars = [[;,."|\]]
	return vim.fn.escape(str, escape_chars)
end

local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
	escape(ru_shift) .. ";" .. escape(en_shift),
	escape(ru) .. ";" .. escape(en),
}, ",")

vim.o.cmdheight = 0
vim.o.statusline = "%{v:lua.vim.fn.reg_recording() != '' ? '[@' . v:lua.vim.fn.reg_recording() . '] ' : ''}" .. vim.o.statusline
