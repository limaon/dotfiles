vim.defer_fn(function()
  pcall(require, "impatient")
end, 0)

-- require('base')
require('highlights')
require('maps')
require('plugins')
