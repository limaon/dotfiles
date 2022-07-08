local M = {}

M.options = {
    -- load your options here or load module with options
    user = function() end,
}

M.ui = {
    transparency = false,
}

M.plugins = {
    override = {},
    remove = {},
    user = {},

    options = {
        lspconfig = {
            setup_lspconf = "", -- path of lspconfig file
        },
        -- statusline = {
        -- separator_style = "default", -- default/round/block/arrow
        -- config = "%!v:lua.require'ui.statusline'.run()",
        -- },
    },
}

-- check core.mappings for table structure
M.mappings = require "core.mappings"

return M
