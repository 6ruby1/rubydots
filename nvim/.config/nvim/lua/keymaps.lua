local map = vim.keymap.set

local function is_git_repo()
	vim.fn.system("git rev-parse --is-inside-work-tree")
	return vim.v.shell_error == 0
end
local function get_git_root()
	local dot_git_path = vim.fn.finddir(".git", ".;")
	return vim.fn.fnamemodify(dot_git_path, ":h")
end

local function inc_rename_fill_word()
	return ":IncRename " .. vim.fn.expand("<cword>")
end

-- Telescope functions ------------------------------------

local function live_grep_from_project_git_root()
	local opts = {}
	if is_git_repo() then
		opts = {
			cwd = get_git_root(),
		}
	end
	require("telescope.builtin").live_grep(opts)
end

local function find_files_from_project_git_root()
	local opts = {}
	if is_git_repo() then
		opts = {
			cwd = get_git_root(),
		}
	end
	require("telescope.builtin").find_files(opts)
end

-- End Telescope functions --------------------------------

local function toggle_autoformat_buff()
	if vim.g.disable_autoformat then
		vim.cmd("FormatEnable")
	else
		vim.cmd("FormatDisable!")
	end
end

local function toggle_autoformat_global()
	if vim.g.disable_autoformat then
		vim.cmd("FormatEnable")
	else
		vim.cmd("FormatDisable")
	end
end

local function duplicate_and_comment()
	-- Exit visual mode
	local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false)

	-- Get selection range
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	-- Yank and paste below
	vim.cmd(start_line .. "," .. end_line .. "yank")
	vim.cmd(end_line .. "put")

	-- Reselect pasted block
	vim.api.nvim_feedkeys("gv", "n", false)

	-- Comment the original selection
	vim.api.nvim_feedkeys("gc", "v", false)
end

-- Toggleterm functions
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	dir = "git_dir",
	direction = "float",
	float_opts = {
		border = "curved",
	},
	-- function to run on opening the terminal
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	-- function to run on closing the terminal
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
})

function _lazygit_toggle()
	lazygit:toggle()
end

local node = Terminal:new({ cmd = "node", hidden = true })

function _node_toggle()
	node:toggle()
end

local python = Terminal:new({ cmd = "python3", hidden = true })

function _python_toggle()
	python:toggle()
end
-- End lazygit functions ----------------------------------
local wk = require("which-key")
local builtin = require("telescope.builtin")
wk.add({
	{
		mode = { "n" },
		{ "<leader>f", group = "Find" },
		{ "<leader>ff", find_files_from_project_git_root, desc = "files" },
		{ "<leader>fw", live_grep_from_project_git_root, desc = "live grep" },
		{ "<leader>fg", builtin.git_files, desc = "git files" },
		{ "<leader>fb", builtin.buffers, desc = "buffers" },
		{ "<leader>bb", builtin.buffers, desc = "Pick buffer" },
		{ "<leader>fi", builtin.grep_string, desc = "word under cursor" },
		{ "<leader>fo", builtin.oldfiles, desc = "oldfiles" },
		{ "<leader>fh", builtin.help_tags, desc = "help" },
		{ "<leader>fm", builtin.man_pages, desc = "man pages" },
		{ "<leader>fr", builtin.lsp_references, desc = "lsp references" },
		{ "<leader>fd", builtin.diagnostics, desc = "diagnostics" },
		{ "<leader>fi", builtin.lsp_implementations, desc = "lsp implementations" },
		{ "<leader>fD", builtin.lsp_type_definitions, desc = "lsp definitions" },
		{ "<leader>fs", builtin.current_buffer_fuzzy_find, desc = "fuzzy word in cur buff" },
		{ "<leader>ft", builtin.builtin, desc = "telescope" },
		{ "<leader>fc", builtin.git_bcommits, desc = "git commits" },
		{ "<leader>fk", builtin.keymaps, desc = "keymaps" },
		{ "<leader>fC", builtin.commands, desc = "commands" },
		{ "<leader>fe", "<cmd>Telescope env<cr>", desc = "env variables" },
		{ "<leader>fa", require("actions-preview").code_actions, desc = "code actions" },
		{
			"<leader>fv",
			function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Nvim config files",
		},
		{
			"<leader>fp",
			function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") .. "/lua/plugins" })
			end,
			desc = "Nvim plugin files",
		},
	},
})

wk.add({
	{
		mode = { "n" },
		{ "<leader>g", group = "Git" },
		{ "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", desc = "Open Lazygit", noremap = true, silent = true },
	},
})

wk.add({
	{
		mode = { "n" },
		{ "<leader>u", group = "UI" },
		{ "<leader>us", "<cmd>setlocal spell!<cr>", desc = "Toggle spell" },
		{ "<leader>uC", "<Cmd>CccHighlighterToggle<CR>", desc = "Toggle color highlight" },
		{ "<leader>uf", toggle_autoformat_buff, desc = "Toggle autoformat (buffer)" },
		{ "<leader>uF", toggle_autoformat_global, desc = "Toggle autoformat (global)" },
		{
			"<leader>ud",
			function()
				local new_config = not vim.diagnostic.config().virtual_lines
				vim.diagnostic.config({ virtual_lines = new_config })
			end,
			desc = "Toggle virtual lines",
		},
		{
			"<leader>uD",
			function()
				local new_config = not vim.diagnostic.config().virtual_text
				vim.diagnostic.config({ virtual_text = new_config })
			end,
			desc = "Toggle virtual text",
		},
	},
})

-- [L]anguage
wk.add({
	{
		mode = { "n" },
		{ "<leader>l", group = "Language" },
		{ "<leader>lg", group = "Go" },
		{ "<leader>lx", group = "Execute" },
		{ "<leader>lr", inc_rename_fill_word, expr = true, desc = "Rename current symbol" },
		{ "<leader>xc", "<Cmd>CccConvert<CR>", desc = "convert color" },
		{ "<leader>xp", "<Cmd>CccPick<CR>", desc = "pick color" },
	},
})

-- Misc
wk.add({
	{
		mode = "n",
		{ "\\", "<cmd>split<cr>", desc = "split horizontal", hidden = true },
		{ "|", "<cmd>vsplit<cr>", desc = "split vertical", hidden = true },
		{ "<leader>c", "<Cmd>:bw<CR>", desc = "Close buffer" },
		{ "<leader>w", "<Cmd>update<CR>", desc = "Write the current buffer.", hidden = true },
		{ "<leader>q", "<Cmd>:quit<CR>", desc = "Quit the current buffer.", hidden = true },
		{ "<leader>Q", "<Cmd>:wqa<CR>", desc = "Quit all buffers and write.", hidden = true },
		{ "<Esc>", "<cmd>nohlsearch<CR>", desc = "Remove hl" },
	},
})
map({ "n", "v", "x" }, "<leader>n", ":norm ", { desc = "norm" })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })
map({ "n" }, "<leader>r", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "S+R wuc" })
map({ "v" }, ">", ">gv", { desc = "Indent line" }) -- Stay in visual after indent
map({ "v" }, "<", "<gv", { desc = "Unindent line" }) -- Stay in visual after unindent
map({ "v" }, "<C-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map({ "v" }, "<C-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map(
	"n",
	"g/",
	":vimgrep /<C-R>//j %<CR>|:cw<CR>",
	{ noremap = true, silent = true, desc = "Populate quickfix with search results" }
)
wk.add({
	{
		mode = { "n", "v" },
		cond = function()
			return pcall(require, "yazi")
		end,
		{ "<leader>e", "<cmd>Yazi<cr>", desc = "File manager" },
		{ "<leader>xe", "<cmd>Yazi cwd<cr>", desc = "Yazi cwd" },
	},
})

-- Buffer
wk.add({
	{
		mode = { "n" },
		{ "<leader>b", group = "Buffer" },

		{ "<leader>bc", "<Cmd>:bw<CR>", desc = "Close buffer" },
		{ "<leader>ba", "<Cmd>:wa<CR>", desc = "Write all changed buffers" },
		{
			"]b",
			function()
				require("heirline-components.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
			end,
			desc = "Next buffer",
		},
		{
			"[b",
			function()
				require("heirline-components.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
			end,
			desc = "Previous buffer",
		},
		{
			">b",
			function()
				require("heirline-components.buffer").move(vim.v.count > 0 and vim.v.count or 1)
			end,
			desc = "Move buffer tab right",
		},
		{
			"<b",
			function()
				require("heirline-components.buffer").move(-(vim.v.count > 0 and vim.v.count or 1))
			end,
			desc = "Move buffer tab left",
		},
	},
})

-- Quickfix
wk.add({
	{
		mode = { "n" },
		{ "<leader>x", group = "Execute" },
		{ "<leader>xl", "<Cmd>lopen<CR>", desc = "open location list" },
		{ "<leader>xq", "<Cmd>copen<CR>", desc = "open quickfix list" },
		{ "]q", "<Cmd>cnext<CR>", desc = "next quickfix" },
		{ "[q", "<Cmd>cprev<CR>", desc = "previous quickfix" },
		{ "]Q", "<Cmd>clast<CR>", desc = "last quickfix" },
		{ "[Q", "<Cmd>cfirst<CR>", desc = "first quickfix" },
		{ "]l", "<Cmd>lnext<CR>", desc = "next loclist" },
		{ "[l", "<Cmd>lprev<CR>", desc = "previous loclist" },
		{ "]L", "<Cmd>llast<CR>", desc = "last loclist" },
		{ "[L", "<Cmd>lfirst<CR>", desc = "first loclist" },
	},
})

-- Terminal
wk.add({
	{
		cond = function()
			return pcall(require, "toggleterm")
		end,

		{ "<leader>t", group = "Terminal", mode = { "n", "v", "x" } },
		{
			mode = "n",
			{ "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal" },
			{ "<leader>t\\", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal" },
			{ "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical" },
			{ "<leader>t|", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical" },
			{ "<leader>tn", "<cmd>lua _node_toggle()<cr>", desc = "ToggleTerm node" },
			{ "<leader>tp", "<cmd>lua _python_toggle()<cr>", desc = "ToggleTerm python" },
			{ "<leader>ts", "<cmd>ToggleTermSendCurrentLine<CR>", desc = "Send line to terminal" },
		},
		{
			mode = { "v", "x" },
			{
				"<leader>ts",
				"<cmd>ToggleTermSendVisualSelection<CR>",
				desc = "Send selection to terminal",
			},
		},
	},

	{ "<C-esc>", [[<C-\><C-n>]], desc = "Escape terminal", mode = "t" },
	{ "<esc><esc>", [[<C-\><C-n>]], desc = "Escape terminal", mode = "t" },
	{ "<C-h>", [[<Cmd>wincmd h<CR>]], desc = "Focus left", mode = "t" },
	{ "<C-j>", [[<Cmd>wincmd j<CR>]], desc = "Focus down", mode = "t" },
	{ "<C-k>", [[<Cmd>wincmd k<CR>]], desc = "Focus up", mode = "t" },
	{ "<C-l>", [[<Cmd>wincmd l<CR>]], desc = "Focus right", mode = "t" },
	{ "<C-w>", [[<C-\><C-n><C-w>]], desc = "Open window menu", mode = "t" },
})

wk.add({
	{
		{ "g", group = "Go", mode = { "n", "v", "x" } },
		{ "gh", "_", noremap = true, desc = "Go to start of line" },
		{ "gl", "$", noremap = true, desc = "Go to end of line" },
		{
			"gK",
			"<esc><cmd>keeppatterns '<,'>-global/$/normal! ddpkJ<cr>",
			mode = { "x", "v" },
			noremap = true,
			desc = "Join lines reversed",
		},
	},
})

-- Debug
local dap = require("dap")
local dapui = require("dapui")
wk.add({
	{
		cond = function()
			return pcall(require, "dap")
		end,
		mode = { "n" },
		{ "<leader>d", group = "Debug" },
		{ "<F1>", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
		{ "<leader>db", dap.toggle_breakpoint, desc = "<F1> Toggle breakpoint" },
		{ "<S-F1>", dap.clear_breakpoints, desc = "Clear breakpoints" },
		{ "<leader>dB", dap.clear_breakpoints, desc = "<S-F1> Clear breakpoints" },
		{ "<F2>", dap.continue, desc = "Start debugger" },
		{ "<leader>dc", dap.continue, desc = "<F2> Start debugger" },
		{ "<leader>dq", dapui.close, desc = "Close UI" },
		{ "<leader>dt", dapui.toggle, desc = "Toggle UI" },
		{ "<S-F2>", dap.terminate, desc = "Terminate debugger" },
		{ "<leader>dQ", dap.terminate, desc = "<S-F2> Terminate debugger" },
		{ "<F3>", dap.step_over, desc = "Step over" },
		{ "<leader>do", dap.step_over, desc = "<F3> Step over" },
		{ "<F4>", dap.step_into, desc = "Step into" },
		{ "<leader>di", dap.step_into, desc = "<F4> Step into" },
		{ "<F5>", dap.step_out, desc = "Step out" },
		{ "<leader>dO", dap.step_out, desc = "<F5> Step out" },
		{ "<F6>", dap.step_back, desc = "Step back" },
		{ "<leader>dI", dap.step_back, desc = "<F6> Step back" },
		{ "<F12>", dap.restart, desc = "Restart debugger" },
		{ "<leader>dr", dap.restart, desc = "<F12> Restart debugger" },
		{ "<leader>ds", dap.run_to_cursor, desc = "Run to cursor" },
		{ "<leader>de", dapui.eval, desc = "Evaluate" },
		{
			"<leader>dE",
			"<cmd>lua require'dapui'.eval(vim.fn.input('[Expression] > '))<cr>",
			desc = "Evaluate input",
		},
	},
})

wk.add({
	{
		mode = "n",
		group = "Center cursor",
		{ "G", "Gzz", noremap = true },
		{ "n", "nzz", noremap = true },
		{ "N", "Nzz", noremap = true },
		{ "*", "*zz", noremap = true },
		{ "#", "#zz", noremap = true },
		{ "g*", "g*zz", noremap = true },
		{ "g#", "g#zz", noremap = true },
	},
})

wk.add({
	{
		mode = "n",
		group = "Window",
		{ "<C-h>", "<C-w><C-h>", desc = "Focus left" },
		{ "<C-l>", "<C-w><C-l>", desc = "Focus right" },
		{ "<C-j>", "<C-w><C-j>", desc = "Focus up" },
		{ "<C-k>", "<C-w><C-k>", desc = "Focus down" },
		{ "<C-Left>", ":vertical resize -2<CR>", desc = "Resize left" },
		{ "<C-Right>", ":vertical resize +2<CR>", desc = "Resize right" },
		{ "<C-Up>", ":resize -2<CR>", desc = "Resize up" },
		{ "<C-Down>", ":resize +2<CR>", desc = "Resize down" },
	},
})

local comment = require("Comment.api")
local com_esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
wk.add({
	{
		cond = function()
			return pcall(require, "Comment")
		end,
		mode = "n",
		{ "<leader>y", group = "Comment", mode = { "n", "v", "x" } },

		{ "yd", "yy<cmd>normal gcc<CR>p", desc = "Dupe and comment" },

		{ "<leader>yc", group = "Linewise", mode = { "n", "v", "x" } },
		{ "<leader>/", comment.toggle.linewise.current, desc = "Comment (lw)" },
		{ "<leader>ycc", comment.call("toggle.linewise", "g@"), expr = true, desc = "Linewise operator" },
		{ "<leader>yd", "yy<cmd>normal gcc<CR>p", desc = "Dupe and comment" },

		{ "<leader>ycO", comment.insert.linewise.above, desc = "Insert comment above" },
		{ "<leader>yco", comment.insert.linewise.below, desc = "Insert comment below" },
		{ "<leader>ycA", comment.insert.linewise.eol, desc = "Insert comment eol" },

		{ "<leader>yb", group = "Blockwise", mode = { "n", "v", "x" } },
		{ "<leader><C-/>", comment.toggle.blockwise.current, desc = "Comment (bw)" },
		{ "<leader>ybb", comment.call("toggle.blockwise", "g@"), expr = true, desc = "Blockwise operator" },

		{ "<leader>yba", group = "Arround" },
		{ "<leader>ybaf", "<cmd>normal gbaf<CR>", desc = "Comment around function" },
		{ "<leader>ybac", "<cmd>normal gbac<CR>", desc = "Comment around class" },
		{ "<leader>ybO", comment.insert.blockwise.above, desc = "Insert comment above" },
		{ "<leader>ybo", comment.insert.blockwise.below, desc = "Insert comment below" },
		{ "<leader>ybA", comment.insert.blockwise.eol, desc = "Insert comment eol" },
	},
	{
		mode = "x",
		{ "<leader>yd", duplicate_and_comment, noremap = true, desc = "Dupe and comment" },
		{
			"<leader>/",
			function()
				vim.api.nvim_feedkeys(com_esc, "nx", false)
				comment.toggle.linewise(vim.fn.visualmode())
			end,
			desc = "Toggle selection linewise",
		},
		{
			"<leader><C-/>",
			function()
				vim.api.nvim_feedkeys(com_esc, "nx", false)
				comment.toggle.blockwise(vim.fn.visualmode())
			end,
			desc = "Toggle selection blockwise",
		},
	},
})
