-- # Utils archives for plugins
require("core.utils")
require("core.options")

vim.defer_fn(function()
    require("core.utils").load_mappings()
end, 0)


-- # General config plugins
require("configs.lsp_installer")
require("configs.lspconfig")
require("configs.cmp")
require("configs.treesitter")
require("configs.nvim_comment")
require("configs.telescope")
require("configs.others").luasnip()
require("configs.others").autopairs()
-- require("configs.others").devicons()


require("ui.colorizer")
-- require("configs.nvim_tree")
-- require("configs.lualine")
-- require("lspsaga")
-- require("gitsigns")
