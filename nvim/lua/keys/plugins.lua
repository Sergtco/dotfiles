require('keys/alias')

--cheatsheet
nm("<leader>s", "<cmd>Cheatsheet<CR>")

--CHADTree
nm("<leader>v", "<cmd>CHADopen<CR>")

--Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--Cokeline
nm( '<S-Tab>',   '<Plug>(cokeline-focus-prev)')
nm( '<Tab>',     '<Plug>(cokeline-focus-next)')
nm( '<Leader>p', '<Plug>(cokeline-switch-prev)')
nm( '<Leader>n', '<Plug>(cokeline-switch-next)')
nm("<Leader>c", "<cmd>bdelete<CR>")

for i = 1,9 do
  nm(('<F%s>'):format(i),      ('<Plug>(cokeline-focus-%s)'):format(i))
  nm(('<Leader>%s'):format(i), ('<Plug>(cokeline-switch-%s)'):format(i))
end

--Toggleterm
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end
--coq
local remap = vim.api.nvim_set_keymap
-- these mappings are coq recommended mappings unrelated to nvim-autopairs
remap('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
remap('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
remap('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
remap('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })


-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

