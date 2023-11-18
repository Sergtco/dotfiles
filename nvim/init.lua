-- require('plugins/packer_install')
require('plugins/lazy')

require('base/search')
require('base/tabs')
require('base/other')
require('base/editor')

require('keys/main')
require('keys/plugins')
 local plugins = {
     'colorscheme',
     'lualine',
     'cokeline',
     'alpha',
     'telescope',
     'cmp',
     'toggleterm',
     'treesitter',
     'lsp/mason',
     'lsp/dap',
     'autopairs',
     'blankline',
     'comment',
     'surround',
     'markdown',
     'chatgpt',
 }
for _, str in ipairs(plugins) do
    local path = 'plugins/' .. str
    require(path)
end
