local status, saga = pcall(require, "lspsaga")
if (not status) then return end

saga.setup {
  diagnostic = {
    show_code_action = false,
  },

  symbol_in_winbar = {
    enable = false,
  },

  ui = {
    -- This option only works in Neovim 0.9
    title = false,
    -- Border type can be single, double, rounded, solid, shadow.
    -- code_action = "",
    code_action = "",
  },
}

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<Leader>j', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
keymap('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', opts)
keymap('n', 'gd', '<Cmd>Lspsaga lsp_finder<CR>', opts)
keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts)
keymap('n', 'gr', '<Cmd>Lspsaga rename<CR>', opts)
keymap({ "n", "v" }, "<leader>ga", "<cmd>Lspsaga code_action<CR>")
