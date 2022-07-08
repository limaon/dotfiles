local map = vim.api.nvim_set_keymap
OPTIONS = { noremap = true }
map('n', '<C-n>', ':NvimTreeToggle<CR>', OPTIONS)
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_git_hl = 1

require('nvim-tree').setup {
    disable_netrw       = true,
    hijack_netrw        = true,
    open_on_setup       = false,
    ignore_ft_on_setup  = {},
    auto_close          = true,
    open_on_tab         = false,
    hijack_cursor       = true,
    update_cwd          = false,
    update_to_buf_dir   = {
        enable = true,
        auto_open = true,
    },
    update_focused_file = {
        enable      = true,
        update_cwd  = true,
        ignore_list = {}
    },
    system_open         = {
        cmd  = nil,
        args = {}
    },
    filters             = {
        dotfiles = false,
        custom = { '.git' }
    },
    git                 = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view                = {
        width = 26,
        height = 30,
        hide_root_folder = true,
        side = 'left',
        auto_resize = false,
        mappings = {
            custom_only = false,
            list = {}
        },
        number = false,
        relativenumber = false
    },
    trash               = {
        cmd = "trash",
        require_confirm = true
    }
}
