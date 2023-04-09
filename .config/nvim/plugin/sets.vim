syntax on
filetype plugin indent on
set encoding=utf-8
set fileencoding=utf-8

" Tabs.
set softtabstop=4
set shiftwidth=2          
set tabstop=2
set expandtab
set smarttab
set smartindent		
set autoindent
set nowrap 
set backspace=indent,eol,start

" Busca
set nohlsearch
set incsearch
set ignorecase
set smartcase
set inccommand=split

" Outros
set number
set rnu
set numberwidth=2
set timeoutlen=500
set undofile
set hidden
set noswapfile
set guicursor=""
set nobackup
set scrolloff=10
set sidescrolloff=6
set autochdir
set pumheight=8
set mouse=a
set nomodeline
set history=10
set splitbelow splitright
set path+=**
set complete+=kspell
set splitbelow splitright
set laststatus=2
set signcolumn=yes
set guicursor=""
let &fcs='eob: '
au BufEnter * set fo-=c fo-=r fo-=o

set updatetime=250
set colorcolumn=80

" Copy/Paste/Cut
set clipboard=unnamedplus

set wildignore+=*.o,*.obj,*.exe,*.so,*.dll,*.pyc,*.svn,*.hg,*.bzr,**/.git/*,
    \*.sass-cache,*.class,*.scssc,*.cssc,sprockets%*,*.lessc,**/node_modules/*

augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
set autoread

" Set up the statusline
set statusline=%<%f\ %h%m%r%=\ %y\ %{FugitiveStatusline()}\ (%{&encoding})\ L:%l/%L\ C:%c\ %P
