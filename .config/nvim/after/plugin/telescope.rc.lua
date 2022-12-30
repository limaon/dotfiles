local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")
local keymap = vim.keymap.set

-- Function to find the project root directory
local function find_project_root()
  -- Replace this with your project's directory structure
  local project_directories = { 'src', 'lib', 'test' }

  -- Traverse up the directory tree until we find a directory containing a project directory
  local current_dir = vim.fn.expand('%:p:h')
  while current_dir ~= '/' do
    for _, project_dir in ipairs(project_directories) do
      local project_dir_path = current_dir .. '/' .. project_dir
      if vim.loop.fs_stat(project_dir_path) then
        return current_dir
      end
    end
    current_dir = current_dir:sub(1, -2):match('.*/')
  end

  -- If we haven't found a project directory, return the current directory
  return vim.fn.expand('%:p:h')
end
local project_root = find_project_root()


telescope.setup {
  defaults = {
    path_display = { "truncate" },
    mappings = {
      n = { ["q"] = actions.close },
      i = { ["<Tab>"] = false, },
    },
    file_ignore_patterns = { '*.pyc', 'node_modules/*', '.git/*' },
  },

  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },

  extensions = {
  },

}

-- All binds
keymap('n', '<leader>ff', function()
  builtin.find_files({
    previewer = false,
    no_ignore = true,
    hidden = true,
    cwd = project_root, -- Use the current directory of the current buffer
  })
end)
keymap('n', '<leader>rp', function()
  builtin.live_grep()
end)
keymap('n', '<C-p>', function()
  builtin.git_files()
end)
keymap('n', '<leader>fb', function()
  builtin.buffers()
end)
keymap('n', '<leader>fh', function()
  builtin.help_tags()
end)
keymap('n', '<leader>;', function()
  builtin.resume()
end)
keymap('n', '<leader>fd', function()
  builtin.diagnostics()
end)
keymap('n', '<leader>k', function()
  builtin.keymaps()
end)
