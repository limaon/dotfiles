local present, treesitter = pcall(require, "nvim-treesitter.configs")

if not present then
    return
end

local option = {
    ensure_installed = {
        "lua",
        "vim",
        "tsx",
        "bash",
        "toml",
        "php",
        "json",
        "html",
        "swift",
        "scss",
        "python",
        "javascript",
    },
    sync_install = false,
    highlight = {
        enable = true, -- false will disable the whole extension
        use_languagetree = true,
        additional_vim_regex_highlighting = true,
    },
    autotag = {
        enable = true,
    },
    autopairs = {
        enabled = true
    },
    indent = {
        enable = true,
    },
}

treesitter.setup(option)
