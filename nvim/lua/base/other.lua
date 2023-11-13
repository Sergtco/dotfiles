local opt = vim.opt
local g = vim.g
--[[ Настройка панелей ]]
--
-- Вертикальные сплиты становятся справа
-- По умолчанию панели в Neovim ставятся в зависимости от расположения текущей панели. Данная настройка поможет нам держать панели в порядке
opt.splitright = true
-- Горизонтальные сплиты становятся снизу
opt.splitbelow = true

--[[ Дополнительные настройки ]]
--
-- Используем системный буфер обмена
opt.clipboard = 'unnamedplus'

-- Отключаем дополнение файлов в конце
opt.fixeol = false

-- Автодополнение (встроенное в Neovim)
-- opt.completeopt = 'menuone,noselect,noinsert'
-- vim.opt.shortmess = vim.opt.shortmess + { c = true }
-- vim.api.nvim_set_option('updatetime', 300)

-- Не автокомментировать новые линии при переходе на новую строку
vim.cmd [[autocmd BufEnter * set fo-=c fo-=r fo-=o]]
--termguicolors
opt.termguicolors = true

--g.mapleader = " "
