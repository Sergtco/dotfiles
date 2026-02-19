Statusline = {}

function Statusline.statusline()
	return table.concat({
		"%<%f",
		"%h%m%r",
		"%=",
		"%-14.(%l,%c%V%)",
		"%P",
		"%{FugitiveStatusline()}",
	}, " ")
end

vim.opt.statusline = "%!v:lua.Statusline.statusline()"
