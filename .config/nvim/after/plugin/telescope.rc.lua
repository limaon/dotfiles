local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require('telescope.actions')

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

-- local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = { ["q"] = actions.close },
      i = { ["<Tab>"] = false, },
    },
  },

  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },

  extensions = {
    file_browser = {
      theme = "dropdown",
      mappings = {
            ["i"] = { ["<C-w>"] = function() vim.cmd('normal vbd') end, },
      },
    },
  },
}

--[[
telescope.load_extension("file_browser")
]]
