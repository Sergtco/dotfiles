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
    if client.name == "omnisharp" then
        client.server_capabilities.semanticTokensProvider = {
            full = vim.empty_dict(),
            legend = {
                tokenModifiers = { "static_symbol" },
                tokenTypes = {
                    "comment",
                    "excluded_code",
                    "identifier",
                    "keyword",
                    "keyword_control",
                    "number",
                    "operator",
                    "operator_overloaded",
                    "preprocessor_keyword",
                    "string",
                    "whitespace",
                    "text",
                    "static_symbol",
                    "preprocessor_text",
                    "punctuation",
                    "string_verbatim",
                    "string_escape_character",
                    "class_name",
                    "delegate_name",
                    "enum_name",
                    "interface_name",
                    "module_name",
                    "struct_name",
                    "type_parameter_name",
                    "field_name",
                    "enum_member_name",
                    "constant_name",
                    "local_name",
                    "parameter_name",
                    "method_name",
                    "extension_method_name",
                    "property_name",
                    "event_name",
                    "namespace_name",
                    "label_name",
                    "xml_doc_comment_attribute_name",
                    "xml_doc_comment_attribute_quotes",
                    "xml_doc_comment_attribute_value",
                    "xml_doc_comment_cdata_section",
                    "xml_doc_comment_comment",
                    "xml_doc_comment_delimiter",
                    "xml_doc_comment_entity_reference",
                    "xml_doc_comment_name",
                    "xml_doc_comment_processing_instruction",
                    "xml_doc_comment_text",
                    "xml_literal_attribute_name",
                    "xml_literal_attribute_quotes",
                    "xml_literal_attribute_value",
                    "xml_literal_cdata_section",
                    "xml_literal_comment",
                    "xml_literal_delimiter",
                    "xml_literal_embedded_expression",
                    "xml_literal_entity_reference",
                    "xml_literal_name",
                    "xml_literal_processing_instruction",
                    "xml_literal_text",
                    "regex_comment",
                    "regex_character_class",
                    "regex_anchor",
                    "regex_quantifier",
                    "regex_grouping",
                    "regex_alternation",
                    "regex_text",
                    "regex_self_escaped_character",
                    "regex_other_escape",
                },
            },
            range = true,
        }
    end
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
    -- ["jdtls"] = function()
    --     require('lspconfig')["jdtls"].setup(coq.lsp_ensure_capabilities({
    --         root_dir = vim.loop.cwd,
    --         on_attach = on_attach,
    --         flags     = lsp_flags,
    --         filetypes = "java"
    --     }))
    -- end

}
--
-- local languages = {
--     ["="] = { misspell },
--     vim = { vint },
--     lua = { stylua, luacheck },
--     go = { staticcheck, goimports, go_vet },
--     python = { autopep8, flake8 },
--     typescript = { prettier, eslint },
--     javascript = { prettier, eslint },
--     typescriptreact = { prettier, eslint },
--     javascriptreact = { prettier, eslint },
--     yaml = { prettier },
--     json = { prettier },
--     html = { prettier },
--     scss = { prettier },
--     css = { prettier },
--     markdown = { prettier, cbfmt },
--     org = { cbfmt },
--     sh = { shellcheck, shfmt },
--     terraform = { terraform },
--     rego = { opa },
-- }
-- require("lspconfig").efm.setup(coq.lsp_ensure_capabilities({
--     cmd = { "/home/sergtco/go/bin/efm-langserver" },
--     on_attach = on_attach,
--     init_options = { documentFormatting = true },
--     root_dir = vim.loop.cwd,
--     filetypes = vim.tbl_keys(languages),
--     settings = {
--         lintDebounce = 100,
--         -- logLevel = 5,
--         languages = languages
--     },
-- }))
vim.diagnostic.config(config)
