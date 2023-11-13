local ok, wilder = pcall(require, 'wilder')
if not ok then
    return
end
--pipeline

wilder.set_option('pipeline', {
    wilder.branch(
        wilder.cmdline_pipeline(),
        wilder.search_pipeline()
    ),
})
--Borders
wilder.set_option('renderer', wilder.popupmenu_renderer(
    wilder.popupmenu_border_theme({
        border = 'rounded',
        highlighter = wilder.basic_highlighter(),
        highlights = {
            border = 'Normal', -- highlight to use for the border
            accent = wilder.make_hl('WilderAccent', 'Pmenu', { { a = 1 }, { a = 1 }, { foreground = '#f4468f' } }),

        },
        -- 'single', 'double', 'rounded' or 'solid'
        -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
        left = { ' ', wilder.popupmenu_devicons() },
        right = { ' ', wilder.popupmenu_scrollbar() },
    })
))

wilder.setup({
    modes = { ':', '/', '?' },
})
