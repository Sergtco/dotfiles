local ok, ts = pcall(require, 'nvim-treesitter.configs')
if not ok then
    return
end

ts.setup {
    -- A list of parser names, or "all" (the four listed parsers should always be installed)
    ensure_installed = {"lua", "python", "rust", "cpp", "vim", "regex", "bash", "markdown", "markdown_inline"},

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        enable = true,
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        additional_vim_regex_highlighting = true,
    },
}
