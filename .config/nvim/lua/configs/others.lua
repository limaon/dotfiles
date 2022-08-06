local M = {}

local load_override = require("core.utils").load_override

M.autopairs = function()
    local present1, autopairs = pcall(require, "nvim-autopairs")
    local present2, cmp = pcall(require, "cmp")

    if not present1 and present2 then
        return
    end

    local options = {
        fast_wrap = {},
        check_ts = true,
        disable_filetype = { "TelescopePrompt", "vim" },
    }

    options = load_override(options, "windwp/nvim-autopairs")
    autopairs.setup(options)

    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

M.luasnip = function()
    local present, luasnip = pcall(require, "luasnip")

    if not present then
        return
    end

    local options = {
        history = true,
        -- updateevents = "TextChanged,TextChangedI",
    }

    options = load_override(options, "L3MON4D3/LuaSnip")
    luasnip.config.set_config(options)
    require("luasnip.loaders.from_vscode").lazy_load()
end

M.devicons = function()
    local present, devicons = pcall(require, "nvim-web-devicons")

    -- if present then
    --    require("base46").load_highlight "devicons"
    -- end
    local options = { override = require("ui.icons").devicons }
    options = require("core.utils").load_override(options, "kyazdani42/nvim-web-devicons")
    devicons.setup(options)
end

M.gitsigns = function()
    local present, gitsigns = pcall(require, "gitsigns")

    if not present then
        return
    end

    local options = {
        signs = {
            -- add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
            -- change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
            -- delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
            -- topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
            -- changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },

            add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
            change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
            delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
            topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
            changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },

        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        update_debounce = 100,
        preview_config = {
            -- Options passed to nvim_open_win
            border = 'single',
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
        },
    }

    options = load_override(options, "lewis6991/gitsigns.nvim")
    gitsigns.setup(options)
end

return M
