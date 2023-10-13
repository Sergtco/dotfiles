local ok, mason = pcall(require, 'mason')
if not ok then
    return
end
local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not ok then
    return
end
require('lsp-progress').setup()

mason.setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
mason_lspconfig.setup()



local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn",  text = "" },
    { name = "DiagnosticSignHint",  text = "" },
    { name = "DiagnosticSignInfo",  text = "" },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
        active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
}


-- vim.cmd [[
--   autocmd CursorHold * lua vim.diagnostic.open_float()
-- ]]

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}
local coq = require("coq")
local util = require("lspconfig.util")
mason_lspconfig.setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup(coq.lsp_ensure_capabilities({
            root_dir = vim.loop.cwd,
            on_attach = on_attach,
            flags = lsp_flags,
        }))
    end,
    ["pylsp"] = function()
        require("lspconfig")["pylsp"].setup(coq.lsp_ensure_capabilities({
            settings  = {
                pylsp = {
                    plugins = {
                        pycodestyle = { enabled = false }, -- not work
                        pyflakes = { enabled = false },
                        pylint = { enabled = false },
                    }
                }
            },
            root_dir  = vim.loop.cwd,
            logLevel  = 5,
            on_attach = on_attach,
            flags     = lsp_flags,
        }))
    end,
    ["jdtls"] = function()
    end,
    ["rust_analyzer"] = function()
        require("rust-tools").setup(coq.lsp_ensure_capabilities({
            server = {
                on_attach = on_attach;
            },
            dap = {
                adapter = {
                    type = "executable",
                    comamand = "$HOME/.local/share/nvim/mason/bin/codelldb",
                    name = "rt_lldb",
                }
            }
        }))
    end,

}
vim.diagnostic.config(config)
