-- [[ Global editor variables. ]] {{{
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = false
vim.g.session_autoload = "no"
vim.g.session_autosave = "no"
vim.g.session_command_aliases = 1
vim.g.autoformat = false
vim.g.markdown_recommended_style = 0
vim.g.netrw_liststyle = 3
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
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "auto"
vim.opt.termguicolors = true
vim.opt.cmdheight = 1
vim.opt.ruler = false
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.pumblend = 5
vim.opt.pumheight = 8
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

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ""
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.swapfile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = false
vim.opt.cursorlineopt = "number,line"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 5
vim.opt.wrap = false
vim.opt.spelllang = { "en_us", "pt_br" }
vim.opt.spell = false
vim.opt.spellsuggest = "best,6"
vim.opt.virtualedit = "block"
vim.opt.whichwrap:append("[,]")
vim.opt.showtabline = 2
vim.opt.modeline = true
vim.opt.modelines = 5
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup//"
vim.opt.directory = vim.fn.stdpath("state") .. "/swap//"
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo//"
vim.opt.sessionoptions:remove("blank")
vim.opt.sessionoptions:append({ "winsize", "globals", "localoptions" })
-- }}}

-- [[ Basic Autocommands/Functions ]] {{{
--  See `:help lua-guide-autocommands`
--  See `:help lua-guide-vim-functions

-- Global Lua function that builds a tabline like "1:[foo.lua] [+]  2:[bar.lua]"
-- Optimized: cache current tab number to avoid repeated calls
function _G.MyTabLine()
	local s = ""
	local tabs = vim.fn.tabpagenr("$")
	local current_tab = vim.fn.tabpagenr()

	for i = 1, tabs do
		local win = vim.fn.tabpagewinnr(i)
		local buf = vim.fn.tabpagebuflist(i)[win]
		local name = vim.fn.fnamemodify(vim.fn.bufname(buf), ":t")
		if name == "" then
			name = "No Name"
		end
		local modified = vim.fn.getbufvar(buf, "&mod") == 1 and " [+]" or ""
		local hl = i == current_tab and "%#TabLineSel#" or "%#TabLine#"
		s = s .. "%" .. i .. "T" .. hl .. " " .. i .. ":[" .. name .. "]" .. modified .. " "
	end
	s = s .. "%#TabLineFill#%T"
	return s
end
vim.opt.tabline = "%!v:lua.MyTabLine()"

-- Utility function to create autocommand groups
local function create_augroup(name, autocmds)
	return vim.api.nvim_create_augroup(name, { clear = true }), autocmds or {}
end

-- Checks if the given node or any of its parent nodes has a type listed in 'types'
-- This is for disable autocompletion menu
local function node_has_type(node, types)
	while node do
		if vim.tbl_contains(types, node:type()) then
			return true
		end
		node = node:parent()
	end
	return false
end

-- Utility function to create autocommands
local function create_autocmd(event, group, pattern, callback, desc)
	vim.api.nvim_create_autocmd(event, {
		group = group,
		pattern = pattern,
		callback = callback,
		desc = desc,
	})
end

-- Function to split window and switch to next buffer
---@diagnostic disable: assign-type-mismatch
local function split_and_switch(split_cmd)
	vim.cmd(split_cmd)
	local buffers = vim.fn.getbufinfo({ buflisted = true })
	if #buffers > 1 then
		vim.cmd("bnext")
	end
end

-- Grouping all basic autocommands
local basic_group = create_augroup("BasicAutocommands")

-- Resize windows when Vim is resized
create_autocmd("VimResized", basic_group, "*", function()
	vim.api.nvim_command("wincmd =")
end, "Resize all windows equally when Vim is resized")

-- Enter insert mode when opening the terminal
create_autocmd("TermOpen", basic_group, "*", function()
	vim.api.nvim_command("startinsert")
end, "Enter insert mode when opening the terminal")

-- Turn off paste mode when leaving insert mode
create_autocmd("InsertLeave", basic_group, "*", function()
	vim.opt.paste = false
end, "Disable paste mode when exiting insert mode")

-- Autocommands to open non-textual files externally
local function is_uri(path)
	return path:match("^[%w+.-]+://") ~= nil
end

local function get_external_file(args)
	local bufnr = (args and args.buf) or 0
	local file = (args and args.file) or ""
	if file == "" then
		file = vim.api.nvim_buf_get_name(bufnr)
	end
	if file == "" then
		return ""
	end
	if is_uri(file) then
		file = vim.uri_to_fname(file)
	end
	if vim.uv.fs_stat(file) then
		return file
	end
	local expanded = vim.fn.expand("%:p")
	if expanded ~= "" and vim.uv.fs_stat(expanded) then
		return expanded
	end
	return ""
end

local function get_open_command(file)
	if vim.fn.has("mac") == 1 then
		if vim.fn.executable("open") == 1 then
			return { "open", file }
		end
		return nil
	end
	if vim.fn.has("wsl") == 1 and vim.fn.executable("wslview") == 1 then
		return { "wslview", file }
	end
	if vim.fn.has("unix") == 1 and vim.fn.executable("xdg-open") == 1 then
		return { "xdg-open", file }
	end
	return nil
end

local openExternalFile = function(args)
	local bufnr = (args and args.buf) or 0
	local file = get_external_file(args)
	if file == "" then
		vim.notify("No valid file to open.", vim.log.levels.WARN)
		return
	end

	local command = get_open_command(file)
	if not command then
		vim.notify("No suitable command to open files externally.", vim.log.levels.ERROR)
		return
	end

	local handle
	handle = vim.uv.spawn(command[1], { args = { unpack(command, 2) } }, function(return_code)
		if handle then
			handle:close()
		end
		if return_code ~= 0 then
			vim.schedule(function()
				vim.notify("Failed to open file: " .. file, vim.log.levels.ERROR)
			end)
		end
	end)

	if not handle then
		vim.notify("Failed to spawn external opener.", vim.log.levels.ERROR)
		return
	end

	vim.api.nvim_buf_delete(bufnr, { force = true })
end

local external_group = create_augroup("OpenExternalFiles")
local external_patterns = { "*.jpeg", "*.jpg", "*.pdf", "*.png", "*.svg", "*.ico" }

create_autocmd("BufReadPost", external_group, external_patterns, function(args)
	openExternalFile(args)
end, "Open non-textual files externally and close the buffer")

-- Automatically regenerate spell file after editing dictionary
create_autocmd("BufWritePost", basic_group, "*/spell/*.add", function()
	vim.cmd("mkspell! %")
end, "Regenerate spell file after editing the dictionary")

-- Disable concealing in specific file types
local concealing_group = create_augroup("DisableConcealing")
local conceal_types = { "json", "jsonc", "markdown" }

create_autocmd("FileType", concealing_group, conceal_types, function()
	vim.opt.conceallevel = 0
end, "Disable concealing for specific file types")

-- Highlight on yank (copying) text
local yank_group = create_augroup("HighlightYank")
create_autocmd("TextYankPost", yank_group, "*", function()
	vim.hl.on_yank()
end, "Highlight text when yanked")

-- Sync syntax highlighting (optimized: only on file read, not on every buffer switch)
local syntax_group = create_augroup("SyncSyntax")
create_autocmd("BufReadPost", syntax_group, "*", function()
	-- Only sync for text files, skip binary and very large files
	if vim.bo.binary or vim.bo.filetype == "" then
		return
	end
	if vim.api.nvim_buf_line_count(0) > 100000 then
		return
	end
	vim.cmd("syntax sync maxlines=100")
end, "Synchronize syntax highlighting when reading file")

-- Remember cursor position when reopening files
local cursor_group = create_augroup("RememberCursorPosition")
create_autocmd("BufReadPost", cursor_group, "*", function()
	local pos = vim.fn.line("'\"")
	if pos > 1 and pos <= vim.fn.line("$") then
		vim.cmd('normal! g`"')
	end
end, "Remember cursor position when reopening files")

-- Settings for text file types
local text_group = create_augroup("TextFileSettings")
create_autocmd({ "BufRead", "BufNewFile" }, text_group, "*.txt", function()
	vim.opt_local.wrap = false
	vim.opt_local.wrapmargin = 2
	vim.opt_local.textwidth = 79
end, "Settings for text files")

-- Settings for Makefile and CMakeLists.txt
local make_group = create_augroup("MakeCMakeSettings")
create_autocmd("FileType", make_group, "make", function()
	vim.bo.expandtab = false
end, "Disable expandtab for Makefiles")

create_autocmd({ "BufNewFile", "BufRead" }, make_group, "CMakeLists.txt", function()
	vim.bo.filetype = "cmake"
end, "Set filetype to cmake for CMakeLists.txt")

-- Language-specific settings (indentation handled by vim-sleuth)
local language_settings = {
	python = {
		buffer = {
			formatoptions = "croq",
			cinwords = "if,elif,else,for,while,try,except,finally,def,class,with",
		},
	},
	markdown = {
		buffer = { formatoptions = "jcroql" },
		window = {
			wrap = false,
			linebreak = true,
			conceallevel = 0,
		},
	},
	tex = {
		buffer = { formatoptions = "jcroql" },
		window = {
			wrap = false,
			linebreak = true,
			conceallevel = 0,
		},
	},
}

local lang_group = create_augroup("LanguageSettings")
create_autocmd("FileType", lang_group, vim.tbl_keys(language_settings), function()
	local ft = vim.bo.filetype
	local settings = language_settings[ft]
	if settings then
		if settings.buffer then
			for option, value in pairs(settings.buffer) do
				vim.bo[option] = value
			end
		end
		if settings.window then
			for option, value in pairs(settings.window) do
				vim.wo[option] = value
			end
		end
	end
end, "Language-specific settings")

-- }}}

-- [[ Basic Keymaps ]] {{{
--  See `:help vim.keymap.set()`
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Select all
keymap("n", "<M-a>", "gg<S-v>G", { desc = "Select all" })

-- Native tabs
keymap("n", "te", ":tabfind ", { noremap = true, silent = false })
keymap("n", "tt", "<cmd>tabnew<cr>", opts)
keymap("n", "tn", "<cmd>tabnext<cr>", opts)
keymap("n", "tp", "<cmd>tabprevious<cr>", opts)
keymap("n", "td", "<cmd>tabclose<cr>", opts)

-- Buffer
keymap("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<s-tab>", "<cmd>bprevious<cr>", { desc = "Preivous buffer" })
keymap("n", "<delete>", "<cmd>bdelete!<cr>", { desc = "Close current" })

-- Split window
keymap("n", "ss", function()
	split_and_switch("split")
end, { desc = "Split below" })
keymap("n", "sv", function()
	split_and_switch("vsplit")
end, { desc = "Split right" })

-- Toggle diagnostics
vim.keymap.set("n", "<leader>dd", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- Move to window
keymap("n", "sh", "<c-w>h", { desc = "Go to left window" })
keymap("n", "sk", "<c-w>k", { desc = "Go to upper window" })
keymap("n", "sj", "<c-w>j", { desc = "Go to lower window" })
keymap("n", "sl", "<c-w>l", { desc = "Go to right window" })

-- Resize window
keymap("n", "<m-up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<m-down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<m-left>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
keymap("n", "<m-right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })

keymap("v", ">", ">gv", { desc = "Visual shifting" })
keymap("v", "<", "<gv", { desc = "Visual shifting" })

-- Keep cursor in the middle of the screen
keymap("n", "<c-d>", "<c-d>zz", { desc = "Scroll down" })
keymap("n", "<c-u>", "<c-u>zz", { desc = "Scroll up" })

-- Keeping search centered
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "N", "Nzzzv", { desc = "Prev search result" })

-- Clear search with <esc>
keymap({ "i", "n" }, "<esc>", "<Cmd>nohlsearch<CR><Esc>", { desc = "Escape and clear hlsearch" })
keymap("n", "/", "zn/", { desc = "Search & Pause Folds" })

-- Better UP / DOWN
keymap("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move lines up" })
keymap("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move lines down" })

-- Keep cursor in place
keymap("n", "J", "mzJ`z", { desc = "Join lines" })

-- Open File browser
keymap("n", "<leader>e", "<cmd>Ex<cr>", { desc = "Open netrw" })

-- Replace World
keymap(
	"n",
	"<leader>s",
	":%s/\\<<c-r><c-w>\\>/<c-r><c-w>/gI<left><left><left>",
	{ silent = false, desc = "Replace word" }
)
keymap("n", "<leader>x", "<cmd>!chmod u+x %<CR>", { desc = "Excutable file" })

-- Get terminal
keymap("n", "<leader>tt", "<cmd>split term://bash<cr>", { silent = false, desc = "Horizontal terminal" })
keymap("n", "<leader>tv", "<cmd>vsplit term://bash<cr>", { silent = false, desc = "Vertical terminal" })
keymap("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Function keys
keymap("n", "<F1>", "<cmd>set rnu!<cr>", { desc = "Set relative number" })
keymap("n", "<F2>", "<cmd>set spell!<cr>", { desc = "Spell language" })
keymap("n", "<F3>", "<cmd>set wrap!<cr>", { desc = "Alternate wrap option" })
keymap("n", "<F4>", "z=", { desc = "Select a correct word" })
keymap("i", "<F5>", "<c-x><c-s>", { desc = "Suggests a list of correct word" })

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
vim.opt.rtp:prepend(lazypath)
-- }}}

-- [[ Configure and install plugins ]] {{{
---@diagnostic disable: missing-fields
require("lazy").setup({

	{ -- Detect tabstop and shiftwidth automatically
		-- Works alongside Neovim's native EditorConfig support (0.9+)
		-- Priority: .editorconfig > guess-indent detection > defaults
		"NMAC427/guess-indent.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			auto_cmd = true,
			filetype_exclude = { "netrw", "tutor" },
			buftype_exclude = { "help", "nofile", "terminal", "prompt" },
		},
	},

	{ -- Theme Solarized
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local ok, theme = pcall(require, "solarized-osaka")
			if ok then
				theme.setup({
					transparent = true,
					use_background = false,
					day_brightness = 0.6,
					styles = {
						sidebars = "normal",
						floats = "normal",
					},
					sidebars = { "qf", "vista_kind", "terminal", "packer", "help" },
					on_highlights = function(_, colors)
						vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = colors.bg, fg = colors.base0 })
						vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = colors.bg, fg = colors.base01 })
						vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = colors.bg, fg = colors.fg })
						vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = colors.bg, fg = colors.fg })
						vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = colors.bg, fg = colors.fg })
					end,
				})
			end
			vim.cmd.colorscheme("solarized-osaka")
		end,
	},

	{
		"limaon/anki-editor.nvim",
		event = "VeryLazy",
		config = function()
			require("anki-editor").setup({
				anki_connect_url = "http://127.0.0.1:8765",
			})
		end,
		keys = {
			{ "<leader>ne", ":AnkiEdit<CR>", desc = "Edit Anki template" },
		},
	},

	{ -- Git
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cond = function()
			local line_count = vim.fn.line("$")
			return line_count < 50000
		end,
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			update_debounce = 250,
			preview_config = { border = "single" },
			on_attach = function(bufnr)
				local gsigns = require("gitsigns")
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- Navigation
				---@diagnostic disable: param-type-mismatch
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gsigns.nav_hunk("next")
						gsigns.preview_hunk_inline()
					end
				end, "[G]itsigns Next [H]unk")
				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gsigns.nav_hunk("prev")
						gsigns.preview_hunk_inline()
					end
				end, "[G]itsigns Prev [H]unk")

				-- Actions
				map("n", "<leader>hs", gsigns.stage_hunk, "[G]itsigns Stage [H]unk")
				map("n", "<leader>hr", gsigns.reset_hunk, "[G]itsigns Reset [H]unk")
				map("n", "<leader>hS", gsigns.stage_buffer, "[G]itsigns Stage [B]uffer")
				map("n", "<leader>hR", gsigns.reset_buffer, "[G]itsigns Reset [B]uffer")
				map("n", "<leader>hp", gsigns.preview_hunk, "[G]itsigns [P]review Hunk")
				map("n", "<leader>hi", gsigns.preview_hunk_inline, "[G]itsigns Preview Hunk [I]nline")

				-- Visual mode actions (corrigido para usar funções com range)
				map("v", "<leader>hs", function()
					gsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "[G]itsigns Stage [H]unk (visual)")
				map("v", "<leader>hr", function()
					gsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "[G]itsigns Reset [H]unk (visual)")

				-- Blame
				map("n", "<leader>hb", function()
					gsigns.blame_line({ full = true })
				end, "[G]itsigns [B]lame Line")
				map("n", "<leader>tb", gsigns.toggle_current_line_blame, "[T]oggle [B]lame")

				-- Diff
				map("n", "<leader>hd", gsigns.diffthis, "[G]itsigns [D]iff This")
				map("n", "<leader>hD", function()
					gsigns.diffthis("~")
				end, "[G]itsigns [D]iff This (~)")

				-- Quickfix
				map("n", "<leader>hq", gsigns.setqflist, "[G]itsigns [Q]uickfix Hunks")
				map("n", "<leader>hQ", function()
					gsigns.setqflist("all")
				end, "[G]itsigns [Q]uickfix All Hunks")

				-- Toggles
				map("n", "<leader>tw", gsigns.toggle_word_diff, "[T]oggle [W]ord Diff")

				-- Text object
				map({ "o", "x" }, "ih", gsigns.select_hunk, "[G]itsigns Select [H]unk")
			end,
		},
	},

	{ -- Plugin vim-fugitive to git integration
		"tpope/vim-fugitive",
		cmd = { "Git", "Gstatus", "Gcommit", "Gpush", "Gpull", "Gblame", "Gdiff", "Glog" },
		event = "VeryLazy",
		config = function()
			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { desc = desc })
			end

			map("n", "<leader>gs", "<cmd>Git<cr>", "[G]it [S]tatus")
			map("n", "<leader>gc", "<cmd>Git commit<cr>", "[G]it [C]ommit")
			map("n", "<leader>gps", "<cmd>Git push<cr>", "[G]it [P]ush")
			map("n", "<leader>gpl", "<cmd>Git pull<cr>", "[G]it Pu[l]l")
			map("n", "<leader>gb", "<cmd>Git blame<cr>", "[G]it [B]lame")
			map("n", "<leader>gdf", "<cmd>Git diff<cr>", "[G]it [D]iff")
			map("n", "<leader>gl", "<cmd>Git log<cr>", "[G]it [L]og")
			map("n", "<leader>gP", "<cmd>Git push -u origin HEAD<cr>", "[G]it Push U[p]stream")
		end,
	},

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",

		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
		config = function()
			local themes = require("telescope.themes")
			local dropdown_no_preview = themes.get_dropdown({ previewer = false })
			local dropdown_with_preview = themes.get_dropdown({})

			require("telescope").setup({
				defaults = {
					-- Appearance
					winblend = 10,
					prompt_prefix = ">> ",
					selection_caret = "=> ",
					entry_prefix = "  ",
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

					-- Behavior
					scroll_strategy = "limit",

					-- Ignored
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
				},
				pickers = {
					find_files = {
						hidden = true,
						find_command = vim.fn.executable("fd") == 1 and { "fd", "--type", "f", "--strip-cwd-prefix" }
							or nil,
					},
					buffers = vim.tbl_deep_extend("force", dropdown_no_preview, {
						sort_mru = true,
						sort_lastused = true,
						ignore_current_buffer = true,
					}),
					keymaps = dropdown_no_preview,
					current_buffer_fuzzy_find = dropdown_no_preview,
					diagnostics = dropdown_with_preview,
					help_tags = dropdown_with_preview,
					git_branches = dropdown_with_preview,
					commands = dropdown_with_preview,
					command_history = dropdown_no_preview,
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
			vim.keymap.set("n", "<leader>sb", builtin.git_branches, { desc = "[S]earch Git [B]ranches" })
			vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set(
				"n",
				"<leader>/",
				builtin.current_buffer_fuzzy_find,
				{ desc = "[/] Fuzzily search in current buffer" }
			)

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
		"lervag/vimtex",
		ft = "tex",
		lazy = false,
		config = function()
			-- vim.g.vimtex_mappings_enabled = 0
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				options = {
					"-pdf",
					"-interaction=nonstopmode",
					"-synctex=1",
					"-file-line-error",
					"-shell-escape",
				},
			}
			vim.g.vimtex_compiler_latexmk_engines = {
				_ = "-xelatex",
			}

			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_view_general_options = {
				"--unique",
				"--synctex-editor-command",
				'nvim --headless -c "VimtexInverseSearch %l %f"',
			}

			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_syntax_enabled = 1
			vim.g.vimtex_syntax_conceal = {
				math_delimiters = 1,
				bangs = 1,
				citations = 1,
				frac = 1,
			}
			vim.g.vimtex_compiler_autowatch = 1
			vim.g.vimtex_format_enabled = 1
			vim.g.vimtex_fold_enabled = 1
			vim.g.vimtex_fold_types = {
				cmd_addplot = { lpos = "#" },
				cmd_foldenv = 1,
				cmd_multiline = 1,
				cmd_singleline = 1,
				cmd_startstop = 1,
				comment = 1,
				delim_inline = 0,
				delim_math = 0,
				brace = 1,
				bracket = 1,
			}
			vim.g.vimtex_matchparen_enabled = 0
			vim.g.vimtex_indent_enabled = 1
			vim.g.vimtex_indent_on_ampersand = 1
			vim.g.vimtex_indent_brace = 1
			vim.g.vimtex_toc_config = {
				name = "TOC",
				layers = { "content", "todo", "include" },
				resize = 0,
				split_width = 40,
				toc_depth = 3,
				indent_levels = 2,
				show_help = 1,
				show_numbers = 1,
				mode = 2,
			}
		end,
	},

	-- [[ LSP Configuration with nvim-lspconfig ]] {{{
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "mason-org/mason.nvim", opts = { ui = { border = "rounded" } } },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Disable LSP diagnostics by default
					vim.diagnostic.enable(false)

					map("K", function()
						vim.lsp.buf.hover({ border = "rounded" })
					end, "Hover")
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
					map("<leader>df", vim.diagnostic.open_float, "[D]ianostic [F]loat")
					map("[d", function()
						vim.diagnostic.jump({ count = 1 })
						vim.diagnostic.open_float()
					end, "Prev diag")
					map("]d", function()
						vim.diagnostic.jump({ count = -1 })
						vim.diagnostic.open_float()
					end, "Next diag")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.inlayHintProvider then
						local detach_augroup = vim.api.nvim_create_augroup("lsp-detach", { clear = true })

						vim.api.nvim_create_autocmd("LspDetach", {
							group = detach_augroup,
							callback = function(_)
								vim.lsp.buf.clear_references()
							end,
						})
					end

					if client and client.server_capabilities.inlayHintProvider then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				jump = { float = true },
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			vim.lsp.config("clangd", {})

			vim.lsp.config("texlab", {
				settings = {
					texlab = {
						build = {
							executable = "latexmk",
							args = {
								"-xelatex",
								"-pdf",
								"-interaction=nonstopmode",
								"-synctex=1",
								"-file-line-error",
								"%f",
							},
							onSave = false, -- Desativado para usar vimtex ao invés
							forwardSearchAfter = false,
						},
						forwardSearch = {
							executable = "zathura",
							args = { "--synctex-forward", "%l:1:%f", "%p" },
						},
					},
				},
			})

			vim.lsp.config("lua_ls", {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
							path = {
								"lua/?.lua",
								"lua/?/init.lua",
							},
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					})
				end,
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = { disable = { "missing-fields" } },
						codeLens = { enable = true },
						hint = { enable = true, semicolon = "Disable" },
					},
				},
			})

			vim.lsp.config("phpactor", {
				cmd = { "phpactor", "language-server" },
				filetypes = { "php" },
				root_markers = { "composer.json", ".git", ".phpactor.json", ".phpactor.yml" },
				init_options = {
					["language_server_phpstan.enabled"] = false,
					["language_server_psalm.enabled"] = false,
				},
				settings = {
					phpactor = {
						completion = {
							insertUseDeclaration = true,
						},
					},
				},
			})

			vim.lsp.config("ts_ls", {
				init_options = { hostInfo = "neovim" },
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
						preferences = {
							importModuleSpecifier = "relative",
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
						preferences = {
							importModuleSpecifier = "relative",
						},
					},
				},
			})

			local ensure_installed = {
				"phpactor",
				"texlab",
				"lua_ls",
				"ts_ls",
				"stylua",
				"eslint_d",
				"prettierd",
				"prettier",
			}
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				automatic_installation = false,
				ensure_installed = {},
			})

			vim.lsp.enable("phpactor")
			vim.lsp.enable("texlab")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("ts_ls")
		end,
	},
	-- }}}

	-- [[ Conform.nvim ]] {{{
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo", "FormatDisable", "FormatEnable" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "[F]ormat buffer or range",
			},
			{
				"<leader>F",
				function()
					vim.g.disable_autoformat = not vim.g.disable_autoformat
					print("Autoformat " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
				end,
				desc = "Toggle autoformat on save",
			},
		},

		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", lsp_format = "fallback" },
				json = { "prettierd", "prettier", stop_after_first = true },
				jsonc = { "prettierd", "prettier", stop_after_first = true },
				php = { "php_cs_fixer", "pint" },
				["*"] = { "codespell" },
				["_"] = { "trim_whitespace" },
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 500,
			},
			format_after_save = {
				lsp_format = "fallback",
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
		},
	},
	-- }}}

	-- [[ mini.nvim ]] {{{
	{
		"echasnovski/mini.nvim",
		config = function()
			-- === UI Utilities ===

			-- Icon provider with LSP integration and nvim-web-devicons mock
			local MiniIcons = require("mini.icons")
			MiniIcons.setup()
			MiniIcons.tweak_lsp_kind()
			MiniIcons.mock_nvim_web_devicons()

			-- Custom statusline with mode, spell, wrap, git, diff, diagnostics, lsp, and fileinfo sections
			local statusline = require("mini.statusline")
			statusline.setup({
				use_icons = vim.g.have_nerd_font,
				set_vim_settings = false,
				content = {
					active = function()
						local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
						local spell = vim.wo.spell and (statusline.is_truncated(120) and "S" or "SPELL") or ""
						local wrap = vim.wo.wrap and (statusline.is_truncated(120) and "W" or "WRAP") or ""
						local git = statusline.section_git({ trunc_width = 40 })
						local diff = statusline.section_diff({ trunc_width = 75 })
						local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
						local lsp = statusline.section_lsp({ trunc_width = 75 })
						local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })

						-- Custom highlight groups for Solarized Osaka theme
						vim.api.nvim_set_hl(0, "MiniStatuslineIndicators", { bg = "#586E75", fg = "#00141A" })
						vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { bg = "#657B83", fg = "#00141A" })
						vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { bg = "#657B83", fg = "#00141A" })

						return statusline.combine_groups({
							{ hl = mode_hl, strings = { mode:upper() } },
							{ hl = "MiniStatuslineIndicators", strings = { spell, wrap } },
							{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
							"%<",
							{ hl = "MiniStatuslineFilename", strings = { vim.fn.expand("%:~:.") } },
							"%=",
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo:upper() } },
							{ hl = mode_hl, strings = { "L:%l C:%c P:%P" } },
						})
					end,
				},
			})

			-- === Text Editing ===

			-- Extended text objects (a/i) with 500 lines search range
			require("mini.ai").setup({ n_lines = 500 })

			-- Auto-brackets and auto-quotes
			require("mini.pairs").setup()

			-- Snippet management with LSP server integration
			local gen_loader = require("mini.snippets").gen_loader
			local MiniSnippets = require("mini.snippets")
			MiniSnippets.setup({
				snippets = {
					gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.lua"),
					gen_loader.from_lang(),
				},
			})
			MiniSnippets.start_lsp_server()

			-- Two-stage LSP completion (LSP first, then fallback)
			require("mini.completion").setup({
				window = {
					info = { width = 40, border = "rounded" },
					signature = { width = 40, border = "rounded" },
				},
				lsp_completion = {
					-- Filter out strings and comments from completion items, and snippets when in comments
					process_items = function(items, base)
						local synID = vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)
						local synName = vim.fn.synIDattr(synID, "name")
						local synParts = vim.split(synName, " ")
						local in_comment = vim.list_contains(synParts, "Comment")

						items = vim.tbl_filter(function(item)
							local insertText = item.insertText or item.label or ""
							local label = item.label or ""

							local dominated_by_string = vim.startswith(insertText, '"')
								and vim.endswith(insertText, '"')
							local dominated_by_comment = vim.startswith(label, "//")
								or vim.startswith(label, "--")

							local COMPLETION_ITEM_KIND = vim.lsp.protocol.CompletionItemKind
							local is_snippet = item.kind == COMPLETION_ITEM_KIND.Snippet
							local should_exclude_snippet = in_comment and is_snippet

							return not dominated_by_string and not dominated_by_comment and not should_exclude_snippet
						end, items)
						return MiniCompletion.default_process_items(items, base)
					end,
				},
			})

			-- Map <C-y> to accept first suggestion without selecting
			local function accept_first_suggestion()
				if vim.fn.pumvisible() == 1 then
					local info = vim.fn.complete_info()
					if info.selected == -1 then
						-- Select first item and confirm: Ctrl-P (0x10) + Ctrl-Y (0x19)
						return "\16\25"
					else
						-- Confirm current selection: Ctrl-Y (0x19)
						return "\25"
					end
				end
				-- Fallback: Ctrl-_ (0x1F) - undo
				return "\31"
			end
			vim.keymap.set("i", "<C-y>", accept_first_suggestion, { expr = true })

			-- LSP capabilities integration
			vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })

			-- === Whitespace ===

			-- Highlight trailing whitespace in normal buffers only
			require("mini.trailspace").setup()
		end,
	},
	-- }}}

	-- [[ nvim-treesitter ]] {{{
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local parsers = {
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"php",
				"phpdoc",
				"vim",
				"vimdoc",
			}

			-- Auto-enable treesitter for supported filetypes
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(args)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
					if ok and stats and stats.size > max_filesize then
						return
					end

					local ft = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(ft)
					if lang and vim.treesitter.language.add(lang) then
						vim.treesitter.start(args.buf, lang)
					end
				end,
				desc = "Enable treesitter highlighting",
			})

			-- Install missing parsers on startup
			local ts = require("nvim-treesitter")
			local available = ts.get_available()
			for _, parser in ipairs(parsers) do
				if vim.tbl_contains(available, parser) and not pcall(vim.treesitter.language.add, parser) then
					ts.install(parser)
				end
			end
		end,
	},
	-- }}}
}, {
	ui = {
		border = "rounded",
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
	performance = {
		reset_packpath = false,
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- }}}

-- }}}

-- vim: ts=2 sts=2 sw=2 et
