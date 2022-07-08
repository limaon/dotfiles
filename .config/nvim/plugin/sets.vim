" Config Basica
"--- Encoding
set encoding=utf-8
set fileencoding=utf-8
set ttyfast

" Identacao por espacos
set backspace=indent,eol,start

" Tabs.
set tabstop=8 softtabstop=4     "Quantidade de espacos por indentacao
set shiftwidth=4                "Quantidade de espacos por auto-indentacao
set expandtab

" Busca
set nohlsearch
set incsearch
set ignorecase		"Ignora o case sensitive nas buscas
set smartcase
set inccommand=split    " splita a tela na hora da subistituicao

"As demais
set number 		" Numera as linhas
set numberwidth=2
" set guicursor=i-ci-v-ve:block-blinkwait700-blinkoff400-blinkon250
set timeoutlen=600      " Tempo para quando for precionada a leader key
set undofile
set smartindent		
set autoindent          " Auto-indenta
set hidden  		" Habilita a edicao de buffers
set noswapfile
set nobackup		" Nao salva arquivos de backup
set scrolloff=8
set autochdir		" Vai para o diretorio do arquivo aberto
set pumheight=8		" Maximo de palavras no popup de autocomplete
set mouse=a	    	" Suporte a mouse
set nomodeline
set history=10
set nowrap 
set splitbelow splitright
set path+=**
set complete+=kspell
set splitbelow splitright
set laststatus=3
let &fcs='eob: '
au BufEnter * set fo-=c fo-=r fo-=o " Disable continius comments
" set signcolumn=yes                " Enable to gitsings

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'('.l:branchname.')':''
endfunction

set statusline=%f\ %h%m%r\ %{StatuslineGit()}%=%y\ \ %-14.(%l,%c%V%)\ %P\ 
set updatetime=250
" set colorcolumn=80                " Linha Vertical do lado direito

"" Copy/Paste/Cut
set clipboard=unnamedplus           "permite copias com a interface grafica

set wildignore+=*.o,*.obj,*.exe,*.so,*.dll,*.pyc,*.svn,*.hg,*.bzr,**/.git/*,
    \*.sass-cache,*.class,*.scssc,*.cssc,sprockets%*,*.lessc,**/node_modules/*

" Splits
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w

nmap <Space> <C-w>w
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l

"" Buffer navegacao
noremap <M-i> :bp<CR>
noremap <M-o> :bn<CR>

"" Fecha o buffer
noremap <DELETE> :bd<CR>

"" Relembrar a posicao do curso quando fechar o editor
augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
set autoread

"------------------- Live Server Web
let g:bracey_server_allow_remote_connections=0
let g:bracey_auto_start_browser=1
let g:bracey_server_port=5050
let g:bracey_refresh_on_save=1
let g:python3_host_prog = '/usr/bin/python3'

" IndentLine
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_char = '┆'
let g:indentLine_faster = 1
