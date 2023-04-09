local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- O mapleader as spacebar
vim.g.mapleader = ' '

-- Increment/decrement
keymap('n', '+', '<C-a>')
keymap('n', '-', '<C-x>')


-- Select all
keymap('n', '<M-a>', 'gg<S-v>G')

-- Tab
keymap('n', 'te', ':tabedit', { silent = true })
keymap('n', 'tt', ':tabnew<CR>', { silent = true })
keymap('n', 'tn', ':tabNext<CR>', { silent = true })
keymap('n', 'tp', ':tabprevious<CR>', { silent = true })
keymap('n', 'td', ':tabclose<CR>', { silent = true })

-- Buffer moves
keymap('n', '<Tab>', ':bnext<CR>', opts)
keymap('n', '<S-Tab>', ':bprevious<CR>', opts)
keymap('n', '<DELETE>', ':bdelete<CR>', opts)

-- Split window
keymap('n', 'ss', ':split<Return><C-w>w<CR>', opts)
keymap('n', 'sv', ':vsplit<Return><C-w>w<CR>', opts)

-- Move window
keymap('', 'sh', '<C-w>h')
keymap('', 'sk', '<C-w>k')
keymap('', 'sj', '<C-w>j')
keymap('', 'sl', '<C-w>l')

-- Resize window
keymap('n', '<C-w><left>', '<C-w><')
keymap('n', '<C-w><right>', '<C-w>>')
keymap('n', '<C-w><up>', '<C-w>+')
keymap('n', '<C-w><down>', '<C-w>-')

-- Move Lines
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("x", "<leader>p", "\"_dP")

-- Replace World
keymap("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", opts)

-- Little File browser
keymap('n', '<leader>e', ':Explore<CR>')

-- Undotree
keymap('n', '<leader>u', vim.cmd.UndotreeToggle, opts)
