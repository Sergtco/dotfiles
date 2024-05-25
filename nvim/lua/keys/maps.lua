local g = vim.g

g.mapleader = " "
-- Buffer motions
vim.keymap.set('n', '<A-[>', "<cmd>bprevious<cr>", {})
vim.keymap.set('n', '<A-]>', "<cmd>bnext<cr>", {})
vim.keymap.set('n', '<A-c>', "<cmd>bdelete<cr>", {})
