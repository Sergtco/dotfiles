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
    'cokeline',
    'alpha',
    'telescope',
    'toggleterm',
    'treesitter',
    'coq',
    'lsp/mason',
    'lsp/dap',
    'noice',
    'autopairs',
    'autosave',
    'blankline',
    'comment',
    'surround',
    'markdown',
    'zenmode',
}
for _, str in ipairs(plugins) do
    local path = 'plugins/' .. str
    require(path)
end
