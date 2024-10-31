return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
    end,
    opts = {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "cpp", "python", "go", },
        sync_install = true,
        highlight = {
            enable = true,
            disable = function(_, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            additional_vim_regex_highlighting = { "ruby", "markdown" },
        },
        indent = { enable = true },
        textobjects = {
            lsp_interop = { enable = true },
            select = {
                enable = true,
                keymaps = {
                    ["ab"] = "@block.outer",
                    ["ib"] = "@block.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["ak"] = "@comment.outer"
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]f"] = "@function.outer",
                    ["]]"] = { query = "@class.outer", desc = "Next class start" },
                    ["]o"] = "@loop.*",
                },
                goto_next_end = {
                    ["]F"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
                goto_next = {
                    ["]c"] = "@conditional.outer",
                    ["]a"] = "@parameter.outer",
                },
                goto_previous = {
                    ["[c"] = "@conditional.outer",
                    ["[a"] = "@parameter.outer",
                }
            }
        },
    }
}
