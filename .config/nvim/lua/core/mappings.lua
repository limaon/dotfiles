local M = {}

M.general = {
    -- Copy all
    -- ["<C-c>"] = { "<cmd> %y+ <CR>", "  copy whole file" },
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
        ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "   find oldfiles" },

        -- git
        ["<leader>fg"] = { "<cmd> Telescope git_files <CR>", "  git files" },

    },
}

return M
