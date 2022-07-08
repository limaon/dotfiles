require 'lualine'.setup {
    options = {
        theme = 'gruvbox-material',
    },

    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff',
            { 'diagnostics', sources = { 'nvim_lsp', 'coc' } } },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },

    tabline = {
        lualine_a = {
            'buffers',
        },
        lualine_z = { 'tabs' }
    }

}
