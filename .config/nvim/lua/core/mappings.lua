local M = {}

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
        ["<leader>ls"] = {
            function()
                vim.lsp.buf.signature_help()
            end,
            "   lsp signature_help",
        },
        -- ["<leader>D"] = {
        --    function()
        --       vim.lsp.buf.type_definition()
        --    end,
        --    "   lsp definition type",
        -- },
        -- ["<leader>ra"] = {
        --    function()
        --       require("ui.renamer").open()
        --    end,
        --    "   lsp rename",
        -- },
        -- ["<leader>ca"] = {
        --    function()
        --       vim.lsp.buf.code_action()
        --    end,
        --    "   lsp code_action",
        -- },
        ["gr"] = {
            function()
                vim.lsp.buf.references()
            end,
            "   lsp references",
        },
        ["<leader>f"] = {
            function()
                vim.diagnostic.open_float()
            end,
            "   floating diagnostic",
        },
        ["<leader>fm"] = {
            function()
                vim.lsp.buf.formatting()
            end,
            "   lsp formatting",
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
        ["<leader>wa"] = {
            function()
                vim.lsp.buf.add_workspace_folder()
            end,
            "   add workspace folder",
        },
        ["<leader>wr"] = {
            function()
                vim.lsp.buf.remove_workspace_folder()
            end,
            "   remove workspace folder",
        },
        ["<leader>wl"] = {
            function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            "   list workspace folders",
        },
    },
}

M.telescope = {
    n = {
        -- find
        ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "  find files" },
        -- ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "  find all" },
        ["<leader>r"] = { "<cmd> Telescope live_grep <CR>", "   live grep" },
        ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "  find buffers" },
        ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "  help page" },

        -- git
        ["<C-p>"] = { "<cmd> Telescope git_files <CR>", "  git files" },

    },
}

return M
