Statusline = {}

function Statusline.statusline()
	return table.concat({
		"%<%f",
		"%h%m%r",
		"%{% luaeval('(package.loaded[''vim.diagnostic''] and #vim.diagnostic.count() ~= 0 and vim.diagnostic.status() .. '' '') or '''' ') %}",
		"%=",
		"%-14.(%l,%c%V%)",
		"%P",
		"%{FugitiveStatusline()}",
	}, " ")
end

vim.opt.statusline = "%!v:lua.Statusline.statusline()"
