local g = vim.g
local config = require("core.utils").load_config()


-- disable some builtin vim plugins
local default_plugins = {
    -- "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    -- "netrw",
    -- "netrwPlugin",
    -- "netrwSettings",
    -- "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    -- "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    -- "python3_provider",
    -- "python_provider",
    -- "node_provider",
    -- "ruby_provider",
    -- "perl_provider",
    "tutor",
    "rplugin",
    "syntax",
    "synmenu",
    "optwin",
    "compiler",
    "bugreport",
    "ftplugin",
}

for _, plugin in pairs(default_plugins) do
    g["loaded_" .. plugin] = 1
end

config.options.user()
