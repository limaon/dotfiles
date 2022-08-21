local M = {}

M.general = {
    n = {
        -- Copy all
        -- ["<C-c>"] = { "<cmd> %y+ <CR>", "  copy whole file" },

        -- Delete a word backwork
        ['dw'] = { 'vb"_d' },

        -- Split window
        ['ss'] = { ':split<Return> <C-w>' },
        ['sv'] = { ':vsplit<Return> <C-w>' },

        --Move window
        ['<Space>'] = { '<C-w>w' },
        ['sh'] = { '<C-w>h' },
        ['sk'] = { '<C-w>k' },
        ['sj'] = { '<C-w>j' },
        ['sl'] = { '<C-w>l' },

        -- Resize window
        ['<C-w><left>'] = { '<C-w><' },
        ['<C-w><right>'] = { '<C-w>>' },
        ['<C-w><up>'] = { '<C-w>+' },
        ['<C-w><down>'] = { '<C-w>-' },

        -- Nav Buffers
        ['<M-i>'] = { ':bp<Return>' },
        ['<M-o>'] = { ':bn<Return>' },
        ['<DELETE>'] = { ':bd<Return>' },


    }
}

M.lspconfig = {
    -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

    n = {
        ["gD"] = {
            function()
                vim.lsp.buf.declaration()
            end,
            "   lsp declaration",
        },
        ["gd"] = {
            function()
                vim.lsp.buf.definition()
            end,
            "   lsp definition",
        },
        ["K"] = {
            function()
                vim.lsp.buf.hover()
            end,
            "   lsp hover",
        },
        ["gi"] = {
            function()
                vim.lsp.buf.implementation()
            end,
            "   lsp implementation",
        },
        ["[d"] = {
            function()
                vim.diagnostic.goto_prev()
            end,
            "   goto prev",
        },
        ["d]"] = {
            function()
                vim.diagnostic.goto_next()
            end,
            "   goto_next",
        },
        ["<leader>q"] = {
            function()
                vim.diagnostic.setloclist()
            end,
            "   diagnostic setloclist",
        },
    },
}

M.telescope = {
    n = {
        -- find
        ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "  find files" },
        ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "   live grep" },
        ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "  find buffers" },
        ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "  help page" },

        -- git
        ["<leader>fg"] = { "<cmd> Telescope git_files <CR>", "  git files" },

    },
}

return M
