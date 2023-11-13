local ok, coke = pcall(require, 'cokeline')
if not ok then
    return
end

local mappings = require('cokeline/mappings')
local get_hex = require('cokeline.hlgroups').get_hl_attr


local comments_fg = get_hex('Comment', 'fg')
local errors_fg = get_hex('DiagnosticError', 'fg')
local warnings_fg = get_hex('DiagnosticWarn', 'fg')



local red = vim.g.terminal_color_1
local green = vim.g.terminal_color_2
local yellow = vim.g.terminal_color_3

local max_buffer_width = 30

local components = {
    left_corner = {
        text = '',
        fg = get_hex('Visual', 'bg'),
        bg = get_hex('Pmenu', 'bg'),
        truncation = { priority = 1 }
    },
    right_corner = {
        text       = '',
        fg         = get_hex('Visual', 'bg'),
        bg         = get_hex('StatusLine', 'bg'),
        truncation = { priority = 1 }
    },
    space = {
        text = ' ',
        truncation = { priority = 1 },
    },

    two_spaces = {
        text = '  ',
        truncation = { priority = 1 },
    },

    separator = {
        text = function(buffer)
            return buffer.index ~= 1 and '▏' or ''
        end,
        truncation = { priority = 1 }
    },
    devicon = {
        text = function(buffer)
            return
                (mappings.is_picking_focus() or mappings.is_picking_close())
                and buffer.pick_letter .. ' '
                or buffer.devicon.icon
        end,
        fg = function(buffer)
            return
                (mappings.is_picking_focus() and yellow)
                or (mappings.is_picking_close() and red)
                or buffer.devicon.color
        end,
        style = function(_)
            return
                (mappings.is_picking_focus() or mappings.is_picking_close())
                and 'italic,bold'
                or nil
        end,
        truncation = { priority = 1 }
    },

    index = {
        text = function(buffer)
            return buffer.index .. ': '
        end,
        truncation = { priority = 1 }
    },
    padding = {
        text = function(buffer) 

        end,
    },
    unique_prefix = {
        text = function(buffer)
            return buffer.unique_prefix
        end,
        fg = comments_fg,
        style = 'italic',
        truncation = {
            priority = 3,
            direction = 'left',
        },
    },

    filename = {
        text = function(buffer)
            return buffer.filename
        end,
        style = function(buffer)
            return
                ((buffer.is_focused and buffer.diagnostics.errors ~= 0)
                    and 'bold,underline')
                or (buffer.is_focused and 'bold')
                or (buffer.diagnostics.errors ~= 0 and 'underline')
                or nil
        end,
        truncation = {
            priority = 2,
            direction = 'left',
        },
    },

    diagnostics = {
        text = function(buffer)
            return
                (buffer.diagnostics.errors ~= 0 and '  ' .. buffer.diagnostics.errors)
                or (buffer.diagnostics.warnings ~= 0 and '  ' .. buffer.diagnostics.warnings)
                or ''
        end,
        fg = function(buffer)
            return
                (buffer.diagnostics.errors ~= 0 and errors_fg)
                or (buffer.diagnostics.warnings ~= 0 and warnings_fg)
                or nil
        end,
        truncation = { priority = 1 },
    },

    close_or_unsaved = {
        text = function(buffer)
            return buffer.is_modified and '󱙃' or ''
        end,
        fg = function(buffer)
            return buffer.is_modified and yellow or nil
        end,
        delete_buffer_on_left_click = true,
        truncation = { priority = 1 },
    },
}

coke.setup({
    default_hl = {
        fg = function(buffer)
            return
                buffer.is_focused
                and get_hex('Normal', 'fg')
                or get_hex('Comment', 'fg')
        end,
        bg = get_hex('visual', 'bg'),
    },
    fill_hl = "Title",
    show_if_buffers_are_at_least = 1,

    buffers = {
        -- filter_valid = function(buffer) return buffer.type ~= 'terminal' end,
        -- filter_visible = function(buffer) return buffer.type ~= 'terminal' end,
        new_buffers_position = 'next',
    },

    rendering = {
        max_buffer_width = max_buffer_width,
    },
    sidebar = {
        filetype = { 'CHADTree' },
        components = {
            components.left_corner,
            components.space,
            { text = 'CHADTree' },
            components.two_spaces,
            components.right_corner,
        },
    },


    components = {
        components.left_corner,
        components.devicon,
        components.unique_prefix,
        components.filename,
        components.diagnostics,
        components.two_spaces,
        components.close_or_unsaved,
        components.right_corner,
    },
})
