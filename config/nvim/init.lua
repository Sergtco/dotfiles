vim.g.mapleader = " "
require("keys")

local o = vim.opt


-- diff
o.diffopt:remove("linematch:40")

o.shortmess:append("c")

-- file system
o.undofile = true
o.swapfile = false
o.exrc = true

o.ignorecase = true
o.smartcase = true

o.expandtab = true
o.shiftround = true
o.shiftwidth = 4
o.softtabstop = 4
o.tabstop = 4

-- fold
vim.wo.foldmethod = "indent"
vim.wo.foldlevel = 99 

--inc
vim.o.nrformats = vim.o.nrformats .. ",unsigned"

--ui
o.relativenumber = true
o.cursorline = true
o.cursorlineopt  = 'screenline,number'
o.ruler = false
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
vim.o.completeopt = "menuone,noselect,fuzzy,nosort"
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

-- Cyrillic keyboard layout
local langmap_keys = {
  'ёЁ;`~', '№;#',
  'йЙ;qQ', 'цЦ;wW', 'уУ;eE', 'кК;rR', 'еЕ;tT', 'нН;yY', 'гГ;uU', 'шШ;iI', 'щЩ;oO', 'зЗ;pP', 'хХ;[{', 'ъЪ;]}',
  'фФ;aA', 'ыЫ;sS', 'вВ;dD', 'аА;fF', 'пП;gG', 'рР;hH', 'оО;jJ', 'лЛ;kK', 'дД;lL', [[жЖ;\;:]], [[эЭ;'\"]],
  'яЯ;zZ', 'чЧ;xX', 'сС;cC', 'мМ;vV', 'иИ;bB', 'тТ;nN', 'ьЬ;mM', [[бБ;\,<]], 'юЮ;.>',
}
vim.o.langmap = table.concat(langmap_keys, ',')
