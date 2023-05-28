local status, cmp = pcall(require, "cmp")
if (not status) then return end
local lspkind = require("lspkind")
local luasnip = require("luasnip")

luasnip.config.set_config({ history = true, updateevents = 'TextChanged,TextChangedI', })
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    ['<C-l>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-h>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  source_priority = ({
    nvim_lsp = 1000,
    cmp_tabnine = 900,
    nvim_lua = 800,
    luasnip = 700,
    buffer = 500,
    path = 250,
  }),
  view = {
    entries = { name = "custom", selection_order = "near_cursor" },
  },
  window = {
    completion = {
      scrollbar = true,
    },
    documentation = {
      border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
    },
  },
  formatting = {
    fields = { "kind", "abbr", "menu", },
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        buffer = "[Buffer]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
        path = "[Path]",
        luasnip = "[Snippet]",
        treesitter = "[Treesitter]",
      })[entry.source.name]
      vim_item.abbr = lspkind.cmp_format({
        with_text = false,
        maxwidth = 18,
        ellipsis_char = "...",
      })(entry, vim_item).abbr
      return vim_item
    end,
  }
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { name = "buffer" },
})

vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]
