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

-- disable auto comment
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

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

-- langmap
local function escape(str)
    -- You need to escape these characters to work correctly
    local escape_chars = [[;,."|\]]
    return vim.fn.escape(str, escape_chars)
end

local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
    -- | `to` should be first     | `from` should be second
    escape(ru_shift) .. ';' .. escape(en_shift),
    escape(ru) .. ';' .. escape(en),
}, ',')

-- highlights yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({
            higroup = "CurSearch",
            timeout = 100,
        })
    end,
})
