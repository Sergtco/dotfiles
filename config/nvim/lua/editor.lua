local o = vim.opt

o.ignorecase = true
o.smartcase = true

-- diff
o.diffopt:remove("linematch:40")

-- file system
o.undofile = true
o.swapfile = false

--indent
local indent = 4
o.expandtab = true
o.shiftround = true
o.shiftwidth = indent
o.softtabstop = indent
o.tabstop = indent

--indent
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

--ui
o.relativenumber = true
o.number = true
o.signcolumn = "yes"
o.scrolloff = 4
o.splitbelow = true
o.splitright = true

-- colors
o.termguicolors = true
o.syntax = "enable"

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

-- cfilter
vim.cmd("packadd cfilter")

-- cmd
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "msg",
		timeout = 3000,
	},
})

vim.api.nvim_create_autocmd("CmdlineChanged", {
	pattern = "[:\\/\\?]",
	callback = function()
		vim.cmd("call wildtrigger()")
	end,
})
o.wildmode = "noselect:lastused,full"
o.wildoptions = "pum"

-- insert mode completion options
o.autocomplete = true
o.complete = "o,.,w,b,u"
o.completeopt = "fuzzy,menuone,noselect,popup"
o.pumheight = 7
o.pummaxwidth = 80

vim.api.nvim_create_autocmd("LspAttach", { command = "setlocal complete=o" })
