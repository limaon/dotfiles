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

return M
