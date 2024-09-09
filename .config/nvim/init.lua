-- [[ Global editor variables. ]] {{{
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = false
vim.g.session_autoload = "no"
vim.g.session_autosave = "no"
vim.g.session_command_aliases = 1
vim.g.autoformat = false
vim.g.markdown_recommended_style = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3
vim.g.netrw_dirhistmax = 0
vim.g.netrw_banner = 1
vim.g.netrw_home = vim.fn.getcwd()
vim.g.netrw_localmovecmd = "mv -f"
vim.g.netrw_localrmdir = "rm -r"
vim.g.netrw_list_hide = ".git,*.o,*.bak,*.pyc,*.swp,*.~,*.tmp,*.temp,node_modules,__pycache__"
-- }}}

-- [[ Setting options ]] {{{
vim.opt.title = true
vim.opt.ttyfast = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.shell = "bash"
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.foldmethod = "marker"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "auto"
-- vim.opt.foldtext = " "
vim.opt.termguicolors = true
vim.opt.cmdheight = 1
vim.opt.ruler = false
vim.opt.showcmd = true
vim.opt.laststatus = 2
-- vim.opt.statusline = "%<%{expand('%:t')}  %h%m%r %= %y |" .. vim.o.encoding .. "| L:%l C:%c P:%P "
vim.opt.pumheight = 8
vim.opt.pumblend = 5
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.wildmenu = true
vim.opt.wildoptions = "pum"
vim.opt.wildignorecase = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o,*.obj,*.pyc,*.class,**/node_modules/*,**/.git/*" })
vim.opt.smoothscroll = false
vim.opt.splitkeep = "cursor"
vim.opt.shortmess:append({ W = true, c = true, C = true, t = true, T = true })
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.path:append({ "**" })
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ""
vim.opt.showmode = false
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.swapfile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "no"
vim.opt.updatetime = 500
vim.opt.timeoutlen = 500
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = false
vim.opt.cursorlineopt = "number" or "number,line"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 5
vim.opt.wrap = false
vim.opt.spelllang = { "en_us", "pt_br" }
vim.opt.spell = false
vim.opt.virtualedit = "block"
vim.opt.whichwrap:append("[,]")
-- }}}

-- [[ Basic Keymaps ]] {{{
--  See `:help vim.keymap.set()`
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- TIP: Disable arrow keys in normal mode
keymap("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
keymap("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
keymap("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
keymap("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Select all
keymap("n", "<M-a>", "gg<S-v>G", { desc = "Select all" })

-- Native tabs
keymap("n", "te", ":tabedit ", { silent = false })
keymap("n", "tt", "<Cmd>tabnew<CR>", opts)
keymap("n", "tn", "<Cmd>tabnext<CR>", opts)
keymap("n", "tp", "<Cmd>tabprevious<CR>", opts)
keymap("n", "td", "<Cmd>tabclose<CR>", opts)

-- Buffer
keymap("n", "<Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", "<Cmd>bprevious<CR>", { desc = "Preivous buffer" })
keymap("n", "<DELETE>", "<Cmd>bdelete!<CR>", { desc = "Close current" })

-- Split window
keymap("n", "ss", "<C-W>s", { desc = "Split below" })
keymap("n", "sv", "<C-W>v", { desc = "Split right" })

-- Move to window
keymap("n", "sh", "<C-w>h", { desc = "Go to left window" })
keymap("n", "sk", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "sj", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "sl", "<C-w>l", { desc = "Go to right window" })

-- Resize window
keymap("n", "<M-Up>", "<Cmd>resize -2<CR>", { desc = "Increase window height" })
keymap("n", "<M-Down>", "<Cmd>resize +2<CR>", { desc = "Decrease window height" })
keymap("n", "<M-Left>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })
keymap("n", "<M-Right>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })

keymap("v", ">", ">gv", { desc = "Visual shifting" })
keymap("v", "<", "<gv", { desc = "Visual shifting" })

-- Keep cursor in the middle of the screen
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- Keeping search centered
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "N", "Nzzzv", { desc = "Prev search result" })

-- Clear search with <esc>
keymap({ "i", "n" }, "<Esc>", "<Cmd>nohlsearch<CR><Esc>", { desc = "Escape and clear hlsearch" })
keymap("n", "/", "zn/", { desc = "Search & Pause Folds" })

-- Better UP / DOWN
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines up" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines down" })

-- Keep cursor in place
keymap("n", "J", "mzJ`z", { desc = "Join lines" })

-- Open File browser
keymap("n", "<leader>e", "<Cmd>Explore<CR>", { desc = "Open Netrw" })

-- Undotree
keymap("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Open undotree for git" })

-- Replace World
keymap(
	"n",
	"<leader>s",
	":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
	{ silent = false, desc = "Replace word" }
)
keymap("n", "<leader>x", "<cmd>!chmod u+x %<CR>", { desc = "Excutable file" })

-- Get terminal
keymap("n", "<leader>tt", "<cmd>split term://bash<cr>", { silent = false, desc = "Horizontal terminal" })
keymap("n", "<leader>tv", "<cmd>vsplit term://bash<cr>", { silent = false, desc = "Vertical terminal" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Function keys
keymap("n", "<F1>", "<cmd>set rnu!<cr>", { desc = "Set relative number" })
keymap("n", "<F2>", "<cmd>set spell!<cr>", { desc = "Spell language" })
keymap("n", "<F3>", "<cmd>set wrap!<cr>", { desc = "Alternate wrap option" })

-- }}}

-- [[ Basic Autocommands ]] {{{
--  See `:help lua-guide-autocommands`

-- Resize windows when terminal changes size
vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.cmd("wincmd =")
	end,
})

-- Remove trailing whitespaces
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		vim.cmd("%s/\\s\\+$//e")
	end,
})

-- Autoclose Netrw buffer
vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		vim.opt_local.bufhidden = "wipe"
	end,
})

-- Autocommand to enter insert mode when opening the terminal
local terminal_group = vim.api.nvim_create_augroup("TerminalGroup", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
	group = terminal_group,
	pattern = "*",
	callback = function()
		vim.cmd("startinsert")
	end,
})

-- Opens non-text files in the default program instead of in Neovim
local augroup_open_files = vim.api.nvim_create_augroup("openFile", {})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup_open_files,
	pattern = { "*.jpeg", "*.jpg", "*.pdf", "*.png", "*.svg" },
	callback = function(ev)
		vim.fn.system("open '" .. vim.fn.expand("%") .. "'")
		vim.api.nvim_buf_delete(ev.buf, {})
	end,
	desc = "Open File",
})

-- automatically regenerate spell file after editing dictionary
local augroup_reg_spell_file = vim.api.nvim_create_augroup("RegenerateSpellFile", {})
vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup_reg_spell_file,
	pattern = "*/spell/*.add",
	callback = function()
		vim.cmd("mkspell! %")
	end,
	desc = "Regenerate spell file",
})

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Helper function to set buffer options
local function set_buffer_options(opts_autocmd)
	for k, v in pairs(opts_autocmd) do
		vim.bo[k] = v
	end
end

-- Create autocommand groups
local function create_augroup(name, autocmds)
	local group = vim.api.nvim_create_augroup(name, { clear = true })
	for _, autocmd in ipairs(autocmds) do
		local event = autocmd[1]
		local opts_autocmd = autocmd[2]
		opts_autocmd.group = group
		vim.api.nvim_create_autocmd(event, opts_autocmd)
	end
end

-- Disable concealing in specific file types
create_augroup("disable_concealing", {
	{
		"FileType",
		{
			pattern = { "json", "jsonc", "markdown" },
			callback = function()
				vim.opt.conceallevel = 0
			end,
		},
	},
})

-- Highlight on yank
create_augroup("highlight_yank", {
	{
		"TextYankPost",
		{
			desc = "Highlight when yanking (copying) text",
			callback = function()
				vim.highlight.on_yank()
			end,
		},
	},
})

-- Sync syntax highlighting
create_augroup("sync_syntax", {
	{ "BufEnter", {
		callback = function()
			vim.cmd("syntax sync maxlines=100")
		end,
	} },
})

-- Remember cursor position
create_augroup("remember_cursor_position", {
	{
		"BufReadPost",
		{
			callback = function()
				local last_line = vim.fn.line("$")
				local cursor_line = vim.fn.line("'\"")
				if cursor_line > 1 and cursor_line <= last_line then
					vim.cmd('normal! g`"')
				end
			end,
		},
	},
})

-- Text file settings
create_augroup("text_file_settings", {
	{
		{ "BufRead", "BufNewFile" },
		{
			pattern = "*.txt",
			callback = function()
				vim.opt.wrap = true
				vim.opt.wrapmargin = 2
				vim.opt.textwidth = 79
			end,
		},
	},
})

-- Makefile and CMakeLists.txt settings
create_augroup("make_cmake_settings", {
	{ "FileType", {
		pattern = "make",
		callback = function()
			vim.bo.expandtab = false
		end,
	} },
	{
		{ "BufNewFile", "BufRead" },
		{
			pattern = "CMakeLists.txt",
			callback = function()
				vim.bo.filetype = "cmake"
			end,
		},
	},
})

-- Language-specific settings
local language_settings = {
	python = {
		expandtab = true,
		shiftwidth = 4,
		tabstop = 8,
		formatoptions = "croq",
		softtabstop = 4,
		cinwords = "if,elif,else,for,while,try,except,finally,def,class,with",
	},
	javascript = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
	typescript = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
	java = { expandtab = true, tabstop = 4, shiftwidth = 4, softtabstop = 4 },
	c = { expandtab = true, tabstop = 4, shiftwidth = 4, softtabstop = 4 },
	cpp = { expandtab = true, tabstop = 4, shiftwidth = 4, softtabstop = 4 },
	ruby = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
	go = { expandtab = false, tabstop = 4, shiftwidth = 4, softtabstop = 4 },
	html = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
	css = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
	json = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
	xml = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
	yaml = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 },
	-- markdown = { wrap = true, linebreak = true },
	tex = { wrap = true, linebreak = true },
	vim = { expandtab = true, tabstop = 4, shiftwidth = 4, softtabstop = 4 },
	toml = { expandtab = true, tabstop = 4, shiftwidth = 4, softtabstop = 4 },
	sh = { expandtab = false, tabstop = 4, shiftwidth = 4, softtabstop = 4 },
	asm = { expandtab = false, tabstop = 8, shiftwidth = 8, softtabstop = 8 },
	make = { expandtab = false },
}

create_augroup("language_settings", {
	{
		"FileType",
		{
			pattern = vim.tbl_keys(language_settings),
			callback = function()
				local ft = vim.bo.filetype
				if language_settings[ft] then
					set_buffer_options(language_settings[ft])
				end
			end,
		},
	},
})

-- }}}

-- [[ Lazy PLUGIN MANAGER ]] {{{
-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath) -- }}}

-- [[ Configure and install plugins ]] {{{
require("lazy").setup({

	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	{
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("solarized-osaka")
		end,
		config = function()
			require("solarized-osaka").setup({
				transparent = true,
				terminal_colors = true,
				styles = {
					comments = { italic = false },
					keywords = { italic = false },
				},
				sidebars = { "qf", "vista_kind", "packer" },
				day_brightness = 0.9,
				dim_inactive = true,
				on_highlights = function(hl, c)
					hl.TelescopeNormal = {
						bg = c.bg,
						-- fg = c.base04,
					}
					hl.TelescopeBorder = {
						bg = c.bg,
						fg = c.fg,
					}
					hl.TelescopePromptNormal = {
						bg = c.bg,
					}
					hl.TelescopePromptBorder = {
						bg = c.bg,
						fg = c.fg,
					}
					hl.TelescopePromptTitle = {
						bg = c.bg,
						fg = c.fg,
					}
				end,
			})
		end,
	},

	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			-- [[ Configure Telescope ]]
			require("telescope").setup({
				defaults = {
					winblend = 10,
					prompt_prefix = ">> ",
					selection_caret = "=> ",
					wrap_results = true,
					scroll_strategy = "limit",
					path_display = { "truncate" },
					file_ignore_patterns = {
						"%.jpg",
						"%.jpeg",
						"%.png",
						"%.svg",
						"%.otf",
						"%.ttf",
						"%.zip",
						"%.DS_Store",
						"%.git/",
						"%.cache/",
						"%.venv/",
						"%.env/",
						"%.vagrant/",
						"%.mypy_cache/",
						"dist/",
						"node_modules/",
						"site-packages/",
						"__pycache__/",
						"migrations/",
						"package-lock.json",
						"yarn.lock",
						"pnpm-lock.yaml",
					},
					layout_config = {
						width = function(_, max_columns, _)
							return math.min(max_columns, 80)
						end,
						height = function(_, _, max_lines)
							return math.min(max_lines, 30)
						end,
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						previewer = false,
					},
					buffers = {
						theme = "dropdown",
						previewer = false,
						sort_mru = true,
						sort_lastused = true,
						ignore_current_buffer = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	-- LSP Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},

	{ "Bilal2453/luvit-meta", lazy = true },

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- This may be unwanted, since they displace some of your code
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable the following language servers
			local servers = {
				clangd = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
			}

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},

		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 600,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},

			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				formatting = {
					expandable_indicator = true,
				},
				window = {
					completion = {
						col_offset = 2,
						winhighlight = "NormalFloat:TelescopeNormal,FloatBorder:TelescopeBorder",
					},
					documentation = {
						-- border = "rounded",
						winhighlight = "NormalFloat:TelescopeNormal,FloatBorder:TelescopeBorder",
					},
				},
				---@diagnostic disable-next-line: missing-fields
				matching = { disallow_prefix_unmatching = true },
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-u>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{
						name = "lazydev",
						group_index = 0,
					},
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750, option = { show_autosnippets = true } },
					{ name = "path", priority = 250 },
					{ name = "buffer", priority = 250 },
				},
			})
		end,
	},

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({
				use_icons = vim.g.have_nerd_font,
				set_vim_settings = false,
				content = {
					active = function()
						-- local statusline = require("mini.statusline")
						local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
						local spell = vim.wo.spell and (statusline.is_truncated(120) and "S" or "SPELL") or ""
						local wrap = vim.wo.wrap and (statusline.is_truncated(120) and "W" or "WRAP") or ""
						local git = statusline.section_git({ trunc_width = 40 })
						local diff = statusline.section_diff({ trunc_width = 75 })
						local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
						local lsp = statusline.section_lsp({ trunc_width = 75 })
						local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })

						vim.api.nvim_set_hl(0, "MiniStatuslineIndicators", { bg = "#586E75", fg = "#00141A" })
						vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { bg = "#657B83", fg = "#00141A" })
						vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { bg = "#657B83", fg = "#00141A" })

						return statusline.combine_groups({
							{ hl = mode_hl, strings = { mode:upper() } },
							{ hl = "MiniStatuslineIndicators", strings = { spell, wrap } },
							{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
							"%<", -- Mark general truncate point
							{ hl = "MiniStatuslineFilename", strings = { vim.fn.expand("%:t") } },
							"%=", -- End left alignment
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo:upper() } },
							{ hl = mode_hl, strings = { "L:%l C:%c P:%P" } },
						})
					end,
				},
			})

			require("mini.pairs").setup()
			require("mini.trailspace").setup()
		end,
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		config = function(_, opts)
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = " ",
			config = " ",
			event = "󰃭 ",
			ft = " ",
			init = "󱌢 ",
			keys = " ",
			plugin = " ",
			runtime = " ",
			require = " ",
			source = " ",
			start = "󱓞 ",
			task = " ",
			lazy = "󰒲 ",
		},
	},
})
-- }}}

-- vim: ts=2 sts=2 sw=2 et
