require('plugins/packer_install')

require('base/search')
require('base/tabs')
require('base/other')
require('base/editor')

require('keys/main')
require('keys/plugins')
local plugins = {
    'colorscheme',
    'lualine',
    'wilder',
    'cokeline',
    'alpha',
    'telescope',
    'coq',
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
