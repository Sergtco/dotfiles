require("mason").setup()
require("mason-lspconfig").setup()



local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
local augroup = vim.api.nvim_create_augroup('AutoFormatting', {})
local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    ---keymaps
    require('keys.plugins').lsp(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end,
        })
    end
end

vim.filetype.add({ extension = { templ = "templ" } })
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("mason-lspconfig").setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            on_attach = on_attach,
            capabilities = capabilities,

        }
    end,
    ["html"] = function()
        require("lspconfig")["html"].setup {
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = { "html", "templ" }
        }
        require("lspconfig")["emmet_language_server"].setup {
            on_attach = on_attach,
            capabilities = capabilities,
            filetypes = { "html", "templ" }
        }
    end
}

local config = {
    -- disable virtual text
    virtual_text = false,
    update_in_insert = true,
    underline = true,
    signs = true,
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

vim.diagnostic.config(config)
