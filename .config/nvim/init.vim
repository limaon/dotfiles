"Run this line at shell(Vim plug)
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

"Vim Plug
call plug#begin('~/.local/share/nvim/plugged')

    " Lsp
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/nvim-lsp-installer'

    " Auto Complete
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'

    "Plug 'glepnir/lspsaga.nvim'

    "Snippets
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'rafamadriz/friendly-snippets'
    
    " Nvim Telescope
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    " This tiny plugin adds vscode-like pictograms to neovim built-in lsp:
    Plug 'onsails/lspkind-nvim'

    Plug 'kyazdani42/nvim-web-devicons' " Habilitar icones
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Habilita cores no tema
    Plug 'windwp/nvim-autopairs'

    Plug 'terrortylor/nvim-comment'
    "Plug 'tpope/vim-surround'
    "Plug 'norcalli/nvim-colorizer.lua' " Cores para o css

    " Git integration
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'
    "Plug 'lewis6991/gitsigns.nvim'

    " Web server
    Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}

"    Plug 'Yggdroot/indentLine' " Para mostrar linhas de indentacao
    Plug 'overcache/NeoSolarized'
    Plug 'norcalli/nvim-colorizer.lua'

call plug#end()

" Requisita o lua/init.lua
lua require("init")
