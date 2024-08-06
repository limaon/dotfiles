" Setup Vim Plug in both editors
if has('nvim')
  let vimplug_dir = expand('~/.local/share/nvim/site/autoload')
else
  let vimplug_dir = expand('~/.vim/autoload')
endif

let vimplug_exists = vimplug_dir . '/plug.vim'
if has('win32') && !has('win64')
  let curl_exists = expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exists = expand('curl')
endif

" Installation of Vim-Plug if not present
if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!" . curl_exists . " -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif


if has('nvim')
  call plug#begin('~/.local/share/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

"*************************
"" Plug install packages
"*************************

" Git
    Plug 'tpope/vim-fugitive'
    Plug 'mbbill/undotree'
    Plug 'tpope/vim-rhubarb'

" Web
    Plug 'alvan/vim-closetag'
    Plug 'hail2u/vim-css3-syntax'
    Plug 'mattn/emmet-vim'
    Plug 'jelera/vim-javascript-syntax'
    Plug 'leafgarland/typescript-vim'


    Plug 'tpope/vim-commentary'
    Plug 'jiangmiao/auto-pairs'

call plug#end()

set nocompatible
if !has('termguicolors')
	set termguicolors
endif

"" Global vars
let g:session_directory="~/.cache/session"
let g:session_autoload="no"
let g:session_autosave="no"
let g:session_command_aliases=1
let g:elm_setup_keybindings=0
let g:elm_format_autosave=1
let g:go_list_type="quickfix"
let g:go_fmt_command="goimports"
let g:go_fmt_fail_silently=1
let g:go_highlight_types=1
let g:go_highlight_fields=1
let g:go_highlight_functions=1
let g:go_highlight_methods=1
let g:go_highlight_operators=1
let g:go_highlight_build_constraints=1
let g:go_highlight_structs=1
let g:go_highlight_generate_tags=1
let g:go_highlight_space_tab_error=0
let g:go_highlight_array_whitespace_error=0
let g:go_highlight_trailing_whitespace_error=0
let g:go_highlight_extra_types=1
let g:haskell_conceal_wide=1
let g:haskell_multiline_strings=1
let g:necoghc_enable_detailed_browse=1
let g:javascript_enable_domhtmlcss=1
let g:yats_host_keyword=1
let g:vim_svelte_plugin_load_full_syntax=1
let g:vue_disable_pre_processors=1
let g:vim_vue_plugin_load_full_syntax=1
let g:netrw_browse_split=0
let g:netrw_dirhistmax=0
let g:netrw_winsize=25
let g:netrw_list_hide='\v\.(swp|bak|pyc|db|git|hg|svn)$'
let g:netrw_liststyle=3
let g:netrw_banner=1
let g:netrw_home=getcwd()

"" General configurations
filetype plugin indent on
syntax on
set title
set ttyfast
set encoding=utf-8
set backspace=indent,eol,start
set noerrorbells
set hidden
set splitbelow
set splitright
set clipboard=unnamedplus
set timeoutlen=500
set updatetime=500
set grepformat="%f:%l:%c:%m"
set grepprg=rg\ --vimgrep
set guicursor=i:block

"" Paths
set path+=**
set noswapfile
set nobackup
set undodir=~/.cache
set undofile

"" Number lines
set number
set relativenumber
set scrolloff=5

"" Tabs
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

"" Search
set ignorecase
set smartcase
set incsearch
set hls
let @/ = ""

" Break lines
set nowrap
set linebreak

"" Folding
set foldmethod=marker
set foldlevelstart=99

"" Fill chars
set nolist
set listchars=tab:›-,space:·,trail:⋯,eol:↲
set fillchars=stlnc:=,vert:│,fold:·,diff:-


"" Orthography
set nospell
set spelllang=en,pt_br

"" Insert mode menu
set complete+=kspell
set completeopt=menuone,longest
set shortmess+=c

"" Color Schemes
colorscheme default


"" Functions
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif


" -----------------------------------------------------------------------------
" Autocmd Rules
" -----------------------------------------------------------------------------

" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

set autoread

" -----------------------------------------------------------------------------
" Autocommands for different file types
" -----------------------------------------------------------------------------

" Common Languages of Programming
autocmd FileType javascript,typescript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType java setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType c,cpp setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType ruby setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType html,css setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType json setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType xml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Languages of Markup
autocmd FileType markdown setlocal wrap linebreak
autocmd FileType tex setlocal wrap linebreak

" Configuration Files
autocmd FileType vim setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType toml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType json setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Scripts Shell
autocmd FileType sh setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

" Archives .asm
autocmd FileType asm setlocal noexpandtab ts=8 sw=8 sts=8

" Arquivos Makefile
autocmd FileType make setlocal noexpandtab 

" Resize windows when terminal change size
autocmd vimresized * wincmd =

"" Commands
" remove trailing whitespaces
command! FixWhitespace :%s/\s\+$//e



" -----------------------------------------------------------------------------
" Keyboard maps
" -----------------------------------------------------------------------------
" Map leader configuration
let mapleader = ' '
let maplocalleader = ' '

" Select all
nnoremap <M-a> gg<S-v>G

" Buffer navigation
nnoremap <Tab> <cmd>bn<cr>
nnoremap <S-Tab> <cmd>bp<cr>
nnoremap <silent> <leader>b :buffers<CR>
nnoremap <DELETE> <cmd>bd<cr>

" Manage Tabs
nnoremap te :tabedit<space>
nnoremap <silent> tt <cmd>tabnew<cr>
nnoremap <silent> tn <cmd>tabnext<cr>
nnoremap <silent> tp <cmd>tabprevious<cr>
nnoremap <silent> td <cmd>tabclose<cr>

" Split and Navigations Windows
nnoremap ss <C-W>s
nnoremap sv <C-W>v
nnoremap sj <C-W>j
nnoremap sk <C-W>k
nnoremap sh <C-W>h
nnoremap sl <C-W>l

" Resize window
nnoremap <M-Up> <cmd>resize +2<cr>
nnoremap <M-Down> <cmd>resize -2<cr>
nnoremap <M-Left> <cmd>vertical resize +2<cr>
nnoremap <M-Right> <cmd>vertical resize -2<cr>
xnoremap > >gv
xnoremap < <gv

" Keep cursor in the middle of the screen
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Keep search centered
nnoremap n nzzzv
nnoremap N Nzzzv

" Clear search with <esc>
inoremap <esc> <cmd>nohlsearch<cr><esc>
nnoremap <esc> <cmd>nohlsearch<cr><esc>

" Better UP / DOWN
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

" Git
nnoremap <leader>u <cmd>UndotreeToggle
nnoremap <leader>gs <cmd>Git
noremap <leader>ga <cmd>Gwrite
noremap <leader>gc :Git commit --verbose<cr>
noremap <leader>gsh <cmd>Git push
noremap <leader>gll <cmd>Git pull
noremap <leader>gb <cmd>Git blame
noremap <leader>gd <cmd>Gvdiffsplit
noremap <leader>gr <cmd>GRemove
nnoremap <leader>o :.GBrowse<cr>

" Others binds

" Keep cursor in the same place
nnoremap J mzJ`z

" Open file explorer (Netrw)
nnoremap <leader>e <cmd>Explore<cr>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Replace Word
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <leader>x <cmd>!chmod u+x %<cr>

" Functions keys
noremap <f1> <cmd>set rnu!<cr>
noremap <f2> <cmd>set spell!<cr>
noremap <f3> <cmd>set wrap!<cr>


" Destaque de coluna...
map <silent> <leader>cc :execute "set cc=" . (&colorcolumn == "" ? "80" : "")<cr>


" Load statusbar file
source ~/.config/nvim/statusbar.vim
