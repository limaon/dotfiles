local status, packer = pcall(require, "packer")
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if (not status) then 
  print('Installing packer...')
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
vim.cmd([[packadd packer.nvim]])


packer.startup(function(use)
  -- Packer
  use 'wbthomason/packer.nvim'
  use {
    'svrana/neosolarized.nvim',
    requires = { 'tjdevries/colorbuddy.nvim' }
  }

  -- LSP UIs
  use({
    'MunifTanjim/prettier.nvim',
    "jose-elias-alvarez/null-ls.nvim",
    "glepnir/lspsaga.nvim",
  })

  -- Installation of LSP/Debuggers/Other
  use({
    "onsails/lspkind-nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  })

  -- Completion
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },             -- Required
      { 'williamboman/mason.nvim' },           -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },         -- Required
      { 'hrsh7th/cmp-nvim-lsp' },     -- Required
      { 'hrsh7th/cmp-buffer' },       -- Optional
      { 'hrsh7th/cmp-path' },         -- Optional
      { 'saadparwaiz1/cmp_luasnip' }, -- Optional
      { 'hrsh7th/cmp-nvim-lua' },     -- Optional

      -- Snippets
      { 'L3MON4D3/LuaSnip' },             -- Required
      { 'rafamadriz/friendly-snippets' }, -- Optional
    }
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    -- "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make",
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons', -- File icons
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate"
  }

  use 'norcalli/nvim-colorizer.lua'
  use 'winston0410/commented.nvim'

  -- AutoPairs
  use({
    'windwp/nvim-ts-autotag',
    'windwp/nvim-autopairs',
  })

  -- Git
  use({
    'lewis6991/gitsigns.nvim',
    'tpope/vim-fugitive',
    'mbbill/undotree',
  })
end)
