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
vim.g.netrw_localrmdir = "rm -rf"
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
-- vim.opt.path:append({ "**" })
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
vim.opt.virtualedit = "block"
vim.opt.whichwrap:append("[,]")
vim.opt.showtabline = 2
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
-- vim.cmd('hi! link TabLineSel Visual')

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

-- Autoclose Netrw buffer
create_autocmd("FileType", basic_group, "netrw", function()
	vim.opt_local.bufhidden = "wipe"
end, "Automatically close the Netrw buffer")

-- Enter insert mode when opening the terminal
create_autocmd("TermOpen", basic_group, "*", function()
	vim.api.nvim_command("startinsert")
end, "Enter insert mode when opening the terminal")

-- Turn off paste mode when leaving insert mode
create_autocmd("InsertLeave", basic_group, "*", function()
	vim.opt.paste = false
end, "Disable paste mode when exiting insert mode")

-- Autocommands to open non-textual files externally
local openExternalFile = function()
	local file = vim.fn.expand("%")
	local command = nil

	-- Detect the operating system and set the appropriate command
	if vim.fn.has("mac") == 1 then
		command = { "open", file }
	elseif vim.fn.has("unix") == 1 then
		command = { "xdg-open", file }
	elseif vim.fn.has("win32") == 1 then
		command = { "cmd", "/c", "start", "", file }
	else
		vim.notify("Operating system not supported for opening files externally.", vim.log.levels.ERROR)
		return
	end

	-- Execute the command asynchronously
	vim.loop.spawn(command[1], { args = { unpack(command, 2) } }, function(return_code)
		if return_code ~= 0 then
			vim.schedule(function()
				vim.notify("Failed to open file: " .. file, vim.log.levels.ERROR)
			end)
		end
	end)

	-- Close the current buffer without saving changes
	vim.api.nvim_buf_delete(0, { force = true })
end

local external_group = create_augroup("OpenExternalFiles")
local external_patterns = { "*.jpeg", "*.jpg", "*.pdf", "*.png", "*.svg", "*.ico" }

create_autocmd(
	"BufReadPost",
	external_group,
	external_patterns,
	openExternalFile,
	"Open non-textual files externally and close the buffer"
)

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
	vim.opt_local.wrap = true
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

-- Language-specific settings
local language_settings = {
	python = {
		buffer = {
			expandtab = true,
			shiftwidth = 4,
			tabstop = 8,
			formatoptions = "croq",
			softtabstop = 4,
			cinwords = "if,elif,else,for,while,try,except,finally,def,class,with",
		},
	},
	markdown = {
		buffer = {
			expandtab = true,
			shiftwidth = 4,
			tabstop = 4,
			softtabstop = 4,
			formatoptions = "jcroql",
		},
		window = {
			wrap = true,
			linebreak = true,
			spell = true,
			conceallevel = 0,
		},
	},
	tex = {
		buffer = {
			expandtab = true,
			shiftwidth = 4,
			tabstop = 4,
			softtabstop = 4,
			formatoptions = "jcroql",
		},
		window = {
			wrap = true,
			linebreak = true,
			spell = true,
			conceallevel = 0,
		},
	},
	lua = {
		buffer = {
			expandtab = true,
			tabstop = 2,
			shiftwidth = 2,
			softtabstop = 2,
		},
	},
	javascript = { buffer = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 } },
	typescript = { buffer = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 } },
	php = { buffer = { expandtab = false, tabstop = 4, shiftwidth = 4, softtabstop = 4 } },
	java = { buffer = { expandtab = true, tabstop = 4, shiftwidth = 4, softtabstop = 4 } },
	c = { buffer = { expandtab = true, tabstop = 4, shiftwidth = 4, softtabstop = 4 } },
	cpp = { buffer = { expandtab = true, tabstop = 4, shiftwidth = 4, softtabstop = 4 } },
	ruby = { buffer = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 } },
	go = { buffer = { expandtab = false, tabstop = 4, shiftwidth = 4, softtabstop = 4 } },
	html = { buffer = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 } },
	css = { buffer = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 } },
	json = { buffer = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 } },
	xml = { buffer = { expandtab = true, tabstop = 2, shiftwidth = 2, softtabstop = 2 } },
	yaml = { buffer = { expandtab = false, tabstop = 2, shiftwidth = 2, softtabstop = 2 } },
	vim = { buffer = { expandtab = true, tabstop = 4, shiftwidth = 4, softtabstop = 4 } },
	toml = { buffer = { expandtab = true, tabstop = 4, shiftwidth = 4, softtabstop = 4 } },
	sh = { buffer = { expandtab = false, tabstop = 4, shiftwidth = 4, softtabstop = 4 } },
	asm = { buffer = { expandtab = false, tabstop = 8, shiftwidth = 8, softtabstop = 8 } },
	make = { buffer = { expandtab = false } },
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

-- TIP: Disable arrow keys in normal mode
-- keymap("n", "<left>", '<cmd>echo "Use h to move!!"<cr>')
-- keymap("n", "<right>", '<cmd>echo "Use l to move!!"<cr>')
-- keymap("n", "<up>", '<cmd>echo "Use k to move!!"<cr>')
-- keymap("n", "<down>", '<cmd>echo "Use j to move!!"<cr>')

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
keymap("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Open Netrw" })

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
		"tpope/vim-sleuth",
		event = { "BufReadPost", "BufNewFile" },
	},

	{ -- Theme Solarized
		"craftzdog/solarized-osaka.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local ok, theme = pcall(require, "solarized-osaka")
			if ok then
				theme.setup({
					style = "storm",
					light_style = "day",
					terminal_colors = true,
					transparent = true,
					lualine_bold = false,
					use_background = false,
					styles = {
						comments = { italic = false },
						keywords = { italic = false },
						sidebars = "normal",
						floats = "normal",
					},
					sidebars = { "qf", "vista_kind", "terminal", "packer", "help" },
					dim_inactive = false,
					hide_inactive_statusline = false,
					day_brightness = 0.6,
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
			signs_staged = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			signs_staged_enable = true,
			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,
			watch_gitdir = { enable = true, follow_files = true },
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = false,
				virt_text_pos = "eol",
				virt_text_priority = 100,
				delay = 1000,
				ignore_whitespace = false,
				use_focus = true,
			},
			sign_priority = 6,
			update_debounce = 250,
			status_formatter = nil,
			max_file_length = 40000,
			preview_config = { border = "single", style = "minimal", relative = "cursor", row = 0, col = 1 },
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
		-- tag = "*",
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
			-- local ivy_theme = themes.get_ivy({})
			-- local cursor_theme = themes.get_cursor({})

			require("telescope").setup({
				defaults = {
					-- Appearance
					winblend = 10,
					prompt_prefix = ">> ",
					selection_caret = "=> ",
					entry_prefix = "  ",
					initial_mode = "insert",
					border = true,
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

					-- Behavior
					wrap_results = true,
					scroll_strategy = "limit",
					sorting_strategy = "descending",
					selection_strategy = "reset",

					-- Exibition
					path_display = { "truncate" },
					color_devicons = true,

					-- Preview
					preview = {
						treesitter = false,
					},

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
		config = function()
			vim.g.vimtex_syntax_enabled = 0
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_method = "latexmk"

			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"
			vim.g.vimtex_format_enabled = 1
			vim.g.vimtex_compiler_autowatch = 1
		end,
		dependencies = {},
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

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config("clangd", {
				capabilities = capabilities,
			})

			vim.lsp.config("texlab", {
				capabilities = capabilities,
				settings = {
					texlab = {
						build = {
							executable = "latexmk",
							args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
							onSave = true,
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
				capabilities = capabilities,
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

			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
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
				"clangd",
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

			vim.lsp.enable("clangd")
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
			notify_on_error = true,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", lsp_format = "fallback" },
				php = { "php_cs_fixer", "pint" },
				["*"] = { "codespell" },
				["_"] = { "trim_whitespace" },
			},
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
	-- }}}

	-- [[ Supermaven ]] {{{
	{
		"supermaven-inc/supermaven-nvim",
		event = "VeryLazy",
		config = function()
			local ok_blink, blink = pcall(require, "blink.cmp")

			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
				},
				ignore_filetypes = {
					help = true,
					gitcommit = false,
					gitrebase = true,
					TelescopePrompt = true,
					dap_repl = true,
				},
				color = {
					suggestion_color = "#586E75",
					cterm = 244,
				},
				log_level = "warn",
				disable_inline_completion = false,
				disable_keymaps = false,
				condition = function()
					if ok_blink and blink and blink.is_visible() then
						return true
					end

					local line_count = vim.api.nvim_buf_line_count(0)
					if line_count > 5000 then
						return true
					end

					local bufname = vim.api.nvim_buf_get_name(0)
					if vim.endswith(bufname, ".env") then
						return true
					end

					return false
				end,
			})

			if ok_blink and blink then
				vim.api.nvim_create_autocmd("User", {
					pattern = "BlinkCmpMenuOpen",
					callback = function()
						local preview = require("supermaven-nvim.completion_preview")
						preview:dispose_inlay()
					end,
				})
			end

			vim.keymap.set("i", "<Tab>", function()
				if ok_blink and blink and blink.is_visible() then
					return vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
				end

				local preview = require("supermaven-nvim.completion_preview")
				if preview.has_suggestion() then
					preview.on_accept_suggestion()
					return
				end

				return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
			end, { desc = "Accept Supermaven suggestion or fallback to Tab" })
		end,
	},
	-- }}}

	-- [[ blink.cmp ]] {{{
	{ -- Autocompletion
		"saghen/blink.cmp",
		event = { "InsertEnter" },
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				config = function()
					local ok, luasnip = pcall(require, "luasnip")
					if not ok then
						return
					end
					local ls = luasnip
					require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/nvim/snippets" } })
					ls.config.set_config({
						history = true,
						-- updateevents = "TextChangedI",
						enable_autosnippets = true,
					})
					vim.keymap.set({ "i" }, "<C-K>", function()
						ls.expand()
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-L>", function()
						ls.jump(1)
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-J>", function()
						ls.jump(-1)
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-E>", function()
						if ls.choice_active() then
							ls.change_choice(1)
						end
					end, { silent = true })
				end,
			},
			"rafamadriz/friendly-snippets",
			{
				"Kaiser-Yang/blink-cmp-avante",
				event = "VeryLazy",
			},
		},
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			enabled = function()
				local disabled = false
				disabled = disabled or (vim.bo.buftype == "prompt")
				disabled = disabled or (vim.bo.filetype == "snacks_input")
				disabled = disabled or (vim.fn.reg_recording() ~= "")
				disabled = disabled or (vim.fn.reg_executing() ~= "")
				return not disabled
			end,
			keymap = {
				preset = "default",
				["<C-y>"] = { "select_and_accept", "fallback" },
				["<S-Tab>"] = {
					function(cmp)
						if cmp.is_menu_visible() then
							return cmp.select_prev()
						elseif cmp.snippet_active() then
							return cmp.snippet_backward()
						end
					end,
					"fallback",
				},
				["<c-l>"] = { "snippet_forward", "fallback" },
				["<c-h>"] = { "snippet_backward", "fallback" },
			},
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "normal",
			},
			completion = {
				ghost_text = { enabled = false },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 1000,
					update_delay_ms = 100,
					treesitter_highlighting = true,
					window = {
						max_width = math.min(80, vim.o.columns),
						max_height = 16,
						border = "rounded",
						winblend = 0,
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
						scrollbar = false,
					},
				},
				list = {
					selection = {
						preselect = function(_)
							return not require("blink.cmp").snippet_active({ direction = 1 })
						end,
						auto_insert = function(_)
							return vim.bo.filetype ~= "markdown"
						end,
					},
					max_items = 3,
				},
				menu = {
					enabled = true,
					auto_show = function()
						local buf = vim.api.nvim_get_current_buf()
						local cache_key = "blink_cmp_auto_show_" .. buf
						local last_check = vim.b[cache_key] or 0
						local now = vim.loop.hrtime()

						if now - last_check < 100000000 then
							return true
						end
						vim.b[cache_key] = now

						local row, col = unpack(vim.api.nvim_win_get_cursor(0))
						local ok, node = pcall(vim.treesitter.get_node, {
							pos = { row - 1, math.max(0, col - 1) },
							ignore_injections = false,
						})
						local reject = {
							"comment",
							"line_comment",
							"block_comment",
							"comment_content",
							-- "string",
							-- "string_start",
							-- "string_content",
							-- "string_end",
						}
						if ok and node and node_has_type(node, reject) then
							return false
						end
						return true
					end,
					max_height = 5,
					min_width = 16,
					border = "none",
					winblend = 10,
					-- winhighlight = "Normal:TelescopeNormal,FloatBorder:TelescopeBorder,CursorLine:BlinkCmpMenuSelection",
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
					scrollbar = false,
					scrolloff = 2,
					direction_priority = { "s", "n" },
					draw = {
						align_to = "cursor",
						padding = { 0, 1 },
						columns = { { "label", "label_description", gap = 0 }, { "kind_icon", "kind" } },
						components = {
							kind_icon = {
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							kind = {
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							label = { width = { fill = true, max = 30 } },
						},
					},
				},
				keyword = { range = "prefix" },
				accept = { auto_brackets = { enabled = true } },
			},
			sources = {
				default = function()
					local ft = (vim.bo.filetype or ""):lower()
					local bufname = vim.api.nvim_buf_get_name(0):lower()
					local is_avante = ft:find("^avante") ~= nil or bufname:find("^avante://") ~= nil

					if is_avante then
						return { "avante" }
					end

					local ok, node = pcall(vim.treesitter.get_node)
					if ok and node and node:type():find("string") then
						return { "path" }
					end
					return {
						"lsp",
						"avante",
						"path",
						"snippets",
						"buffer",
					}
				end,

				providers = {
					lsp = { fallbacks = { "lazydev" } },
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
					},
					avante = {
						name = "Avante",
						module = "blink-cmp-avante",
					},
					path = {
						opts = {
							trailing_slash = true,
							label_trailing_slash = true,
							get_cwd = function()
								return vim.fn.expand("%:p:h")
							end,
						},
					},
					snippets = {
						score_offset = -1,
						opts = {
							use_show_condition = true,
							show_autosnippets = true,
							prefer_doc_trig = false,
							use_label_description = true,
						},
					},
					buffer = {
						score_offset = -3,
						opts = {
							use_cache = true,
							max_sync_buffer_size = 5000,
							max_async_buffer_size = 50000,
						},
					},
				},
			},
			snippets = {
				preset = "luasnip",
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
				max_typos = function(keyword)
					return math.floor(#keyword / 4)
				end,
				frecency = {
					enabled = true,
					path = vim.fn.stdpath("state") .. "/blink/cmp/frecency.dat",
					unsafe_no_lock = false,
				},
				use_proximity = true,
				sorts = {
					"exact",
					"score",
					"sort_text",
				},
				prebuilt_binaries = {
					download = true,
				},
			},
			signature = {
				enabled = true,
				window = {
					max_width = 50,
					border = "rounded",
					winblend = 10,
				},
			},
		},
	},
	-- }}}

	-- [[ mini.nvim ]] {{{
	{
		"echasnovski/mini.nvim",
		config = function()
			local MiniIcons = require("mini.icons")
			MiniIcons.setup()
			MiniIcons.tweak_lsp_kind()
			MiniIcons.mock_nvim_web_devicons()
			require("mini.ai").setup({ n_lines = 500 })

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

			require("mini.pairs").setup()
			require("mini.trailspace").setup({
				only_in_normal_buffers = true,
			})
		end,
	},
	-- }}}

	-- [[ nvim-treesitter ]] {{{
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				-- install_dir = vim.fn.stdpath("data") .. "/site",
			})

			local parsers = {
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
			}
			require("nvim-treesitter").install(parsers)

			local skip_filetypes = {
				"TelescopePrompt",
				"blink-cmp-menu",
				"snacks_input",
				"",
			}

			local function should_use_treesitter()
				local ft = vim.bo.filetype
				if vim.tbl_contains(skip_filetypes, ft) then
					return false
				end
				if vim.bo.binary then
					return false
				end
				if ft == "" then
					return false
				end
				return true
			end

			local ts_group = vim.api.nvim_create_augroup("TreesitterFeatures", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = ts_group,
				pattern = "*",
				callback = function()
					if not should_use_treesitter() then
						return
					end

					local ok, _ = pcall(vim.treesitter.start)
					if not ok then
						return
					end

					if vim.bo.filetype ~= "ruby" then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
				desc = "Enable treesitter features",
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = ts_group,
				pattern = "ruby",
				callback = function()
					if should_use_treesitter() then
						pcall(vim.treesitter.start)
					end
				end,
				desc = "Enable treesitter for ruby",
			})
		end,
	},
	-- }}}

	-- [[ Avante.nvim ]] {{{
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false,
		build = "make",
		opts = {
			instructions_file = "avante.md",
			provider = "glm",
			-- auto_suggestions_provider = "glm",
			mode = "agentic",
			providers = {
				claude = {
					endpoint = "https://api.anthropic.com",
					model = "claude-sonnet-4-5-20250929",
					context_window = 200000,
					api_key_name = "ANTHROPIC_API_KEY",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 4096,
					},
				},
				glm = {
					__inherited_from = "openai",
					endpoint = "https://api.z.ai/api/coding/paas/v4",
					model = "glm-4.7",
					api_key_name = "Z_AI_API_KEY",
					timeout = 30000,
					disable_tools = false,
					model_names = {
						"GLM-4.7",
						"GLM-4.5-air",
					},
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 20480,
					},
				},
				copilot = {
					endpoint = "https://api.githubcopilot.com",
					model = "grok-code-fast-1",
					timeout = 30000,
					extra_request_body = {
						max_tokens = 20480,
					},
				},
			},
			acp_providers = {
				["opencode"] = {
					command = vim.fn.system("which opencode"):gsub("\n", ""),
					timeout = 30000,
					args = {
						"acp",
						"--print-logs",
						"--log-level",
						"DEBUG",
						"--cwd",
						vim.fn.getcwd(),
					},
				},
			},
			behaviour = {
				auto_suggestions = false,
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = true,
				minimize_diff = true,
				enable_token_counting = false,
				auto_add_current_file = true,
				auto_approve_tool_permissions = false,
				confirmation_ui_style = "popup",
				acp_follow_agent_locations = true,
			},
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub and hub:get_active_servers_prompt() or ""
			end,
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
			disabled_tools = {
				"list_files",
				"search_files",
				"read_file",
				"create_file",
				"rename_file",
				"delete_file",
				"create_dir",
				"rename_dir",
				"delete_dir",
			},
			windows = {
				position = "left",
				sidebar_header = {
					enabled = true,
					align = "center",
					rounded = true,
				},
				spinner = {
					editing = { "", "", "" },
					generating = { "", "", "" },
					thinking = { "󰳟 ", "󰊠 " },
				},
				input = {
					start_insert = false,
				},
				ask = {
					start_insert = false,
				},
				edit = {
					border = "single",
					start_insert = true,
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						extension = "png",
						template = "![$CURSOR]($FILE_PATH)",
						url_encode_path = false,
						use_absolute_path = false,
						use_cursor_in_template = true,
						insert_mode_after_paste = true,
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
					},
					filetypes = {
						markdown = {
							url_encode_path = true,
							template = "![$CURSOR]($FILE_PATH)",
						},
					},
				},
				keys = {
					{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
				},
			},
		},
	},

	-- }}}

	-- [[ MCPHub.nvim ]] {{{
	{
		"ravitemer/mcphub.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = "MCPHub",
		build = "npm install -g mcp-hub@latest",
		config = function()
			require("mcphub").setup({
				config = vim.fn.expand("~/.config/mcphub/servers.json"),
				auto_approve = false,
				extensions = {
					avante = {
						enabled = true,
						make_slash_commands = true,
					},
				},
				on_error = function(err)
					vim.notify("MCPHub error: " .. tostring(err), vim.log.levels.ERROR)
				end,
			})
		end,
	},
	-- }}}
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

-- vim: ts=2 sts=2 sw=2 et
