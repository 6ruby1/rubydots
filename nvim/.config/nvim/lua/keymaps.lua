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
map({ "n" }, "<leader>g", "", { desc = "Git" })
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

vim.api.nvim_set_keymap(
	"n",
	"<leader>gg",
	"<cmd>lua _lazygit_toggle()<CR>",
	{ noremap = true, silent = true, desc = "Open Lazygit" }
)

local node = Terminal:new({ cmd = "node", hidden = true })

function _node_toggle()
	node:toggle()
end

local python = Terminal:new({ cmd = "python3", hidden = true })

function _python_toggle()
	python:toggle()
end
-- End lazygit functions ----------------------------------

local builtin = require("telescope.builtin")
map({ "n" }, "<leader>f", "", { desc = "Find" })
map({ "n" }, "<leader>ff", find_files_from_project_git_root, { desc = "files" })
map({ "n" }, "<leader>fw", live_grep_from_project_git_root, { desc = "live grep" })
map({ "n" }, "<leader>fg", builtin.git_files, { desc = "git files" })
map({ "n" }, "<leader>fb", builtin.buffers, { desc = "buffers" })
map({ "n" }, "<leader>bb", builtin.buffers, { desc = "Pick buffer" })
map({ "n" }, "<leader>fi", builtin.grep_string, { desc = "word under cursor" })
map({ "n" }, "<leader>fo", builtin.oldfiles, { desc = "oldfiles" })
map({ "n" }, "<leader>fh", builtin.help_tags, { desc = "help" })
map({ "n" }, "<leader>fm", builtin.man_pages, { desc = "man pages" })
map({ "n" }, "<leader>fr", builtin.lsp_references, { desc = "lsp references" })
map({ "n" }, "<leader>fd", builtin.diagnostics, { desc = "diagnostics" })
map({ "n" }, "<leader>fi", builtin.lsp_implementations, { desc = "lsp implementations" })
map({ "n" }, "<leader>fD", builtin.lsp_type_definitions, { desc = "lsp definitions" })
map({ "n" }, "<leader>fs", builtin.current_buffer_fuzzy_find, { desc = "fuzzy word in cur buff" })
map({ "n" }, "<leader>ft", builtin.builtin, { desc = "telescope" })
map({ "n" }, "<leader>fc", builtin.git_bcommits, { desc = "git commits" })
map({ "n" }, "<leader>fk", builtin.keymaps, { desc = "keymaps" })
map({ "n" }, "<leader>fC", builtin.commands, { desc = "commands" })
map({ "n" }, "<leader>fe", "<cmd>Telescope env<cr>", { desc = "env variables" })
map({ "n" }, "<leader>fa", require("actions-preview").code_actions, { desc = "code actions" })

-- [U]I
map({ "n" }, "<leader>u", "", { desc = "UI" })
map({ "n" }, "<leader>us", "<cmd>setlocal spell!<cr>", { desc = "Toggle spell" })
map({ "n" }, "<leader>uC", "<Cmd>CccHighlighterToggle<CR>", { desc = "Toggle color highlight" })
map({ "n" }, "<leader>uf", toggle_autoformat_buff, { desc = "Toggle autoformat (buffer)" })
map({ "n" }, "<leader>uF", toggle_autoformat_global, { desc = "Toggle autoformat (global)" })
map({ "n" }, "<leader>ud", function()
	local new_config = not vim.diagnostic.config().virtual_lines
	vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual_text" })
map({ "n" }, "<leader>uD", function()
	local new_config = not vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })

-- [L]anguage
map({ "n" }, "<leader>l", "", { desc = "Language" })
map({ "n" }, "<leader>lr", inc_rename_fill_word, { expr = true, desc = "Rename current symbol" })
map({ "n", "v", "x" }, "<leader>lf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
map({ "n" }, "<leader>xc", "<Cmd>CccConvert<CR>", { desc = "convert color" })
map({ "n" }, "<leader>xp", "<Cmd>CccPick<CR>", { desc = "pick color" })

-- Misc
map({ "n" }, "\\", "<cmd>split<cr>", { desc = "split horizontal" })
map({ "n" }, "|", "<cmd>vsplit<cr>", { desc = "split vertical" })
map({ "n" }, "<leader>c", "<Cmd>:bw<CR>", { desc = "Close buffer" })
map({ "n" }, "<leader>w", "<Cmd>update<CR>", { desc = "Write the current buffer." })
map({ "n" }, "<leader>q", "<Cmd>:quit<CR>", { desc = "Quit the current buffer." })
map({ "n" }, "<leader>Q", "<Cmd>:wqa<CR>", { desc = "Quit all buffers and write." })
map({ "n" }, "<Esc>", "<cmd>nohlsearch<CR>")
map({ "n", "v", "x" }, "<leader>o", "<Cmd>source %<CR>", { desc = "Source " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>O", "<Cmd>restart<CR>", { desc = "Restart vim." })
map({ "n", "v", "x" }, "<leader>n", ":norm ", { desc = "Enter norm command" })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })
map({ "n" }, "<leader>r", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "Search and replace word under cursor" })
map({ "v" }, ">", ">gv", { desc = "Indent line" }) -- Stay in visual after indent
map({ "v" }, "<", "<gv", { desc = "Unindent line" }) -- Stay in visual after unindent
map({ "n" }, "<leader>xv", function()
	require("telescope.builtin").find_files({
		cwd = vim.stdpath("config"),
	})
end, { desc = "edit config" })
map(
	"n",
	"g/",
	":vimgrep /<C-R>//j %<CR>|:cw<CR>",
	{ noremap = true, silent = true, desc = "Populate quickfix with search results" }
)

-- Buffer
map({ "n" }, "<leader>b", "", { desc = "Buffer" })
map({ "n" }, "<leader>bc", "<Cmd>:bw<CR>", { desc = "Close buffer" })
map({ "n" }, "<leader>ba", "<Cmd>:wa<CR>", { desc = "Write all changed buffers" })
map({ "n" }, "]b", function()
	require("heirline-components.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
end, { desc = "Next buffer" })
map({ "n" }, "[b", function()
	require("heirline-components.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
end, { desc = "Previous buffer" })
map({ "n" }, ">b", function()
	require("heirline-components.buffer").move(vim.v.count > 0 and vim.v.count or 1)
end, { desc = "Move buffer tab right" })
map({ "n" }, "<b", function()
	require("heirline-components.buffer").move(-(vim.v.count > 0 and vim.v.count or 1))
end, { desc = "Move buffer tab left" })

-- Quickfix
map({ "n" }, "<leader>xl", "<Cmd>lopen<CR>", { desc = "open location list" })
map({ "n" }, "<leader>xq", "<Cmd>copen<CR>", { desc = "open quickfix list" })
map({ "n" }, "]q", "<Cmd>cnext<CR>", { desc = "next quickfix" })
map({ "n" }, "[q", "<Cmd>cprev<CR>", { desc = "previous quickfix" })
map({ "n" }, "]Q", "<Cmd>clast<CR>", { desc = "last quickfix" })
map({ "n" }, "[Q", "<Cmd>cfirst<CR>", { desc = "first quickfix" })
map({ "n" }, "]l", "<Cmd>lnext<CR>", { desc = "next loclist" })
map({ "n" }, "[l", "<Cmd>lprev<CR>", { desc = "previous loclist" })
map({ "n" }, "]L", "<Cmd>llast<CR>", { desc = "last loclist" })
map({ "n" }, "[L", "<Cmd>lfirst<CR>", { desc = "first loclist" })

-- Terminal
map({ "n", "v", "x" }, "<leader>t", "", { desc = "Terminal" })
map({ "n" }, "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "ToggleTerm Float" })
map({ "n" }, "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", { desc = "ToggleTerm horizontal" })
map({ "n" }, "<leader>t\\", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", { desc = "ToggleTerm horizontal" })
map({ "n" }, "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", { desc = "ToggleTerm vertical" })
map({ "n" }, "<leader>t|", "<cmd>ToggleTerm size=80 direction=vertical<cr>", { desc = "ToggleTerm vertical" })
map({ "t" }, "<C-esc>", [[<C-\><C-n>]], { desc = "Escape terminal" })
map({ "t" }, "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Focus left" })
map({ "t" }, "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Focus down" })
map({ "t" }, "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Focus up" })
map({ "t" }, "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Focus right" })
map({ "t" }, "<C-w>", [[<C-\><C-n><C-w>]], { desc = "Open window menu" })
map({ "n" }, "<leader>tn", "<cmd>lua _node_toggle()<cr>", { desc = "Toggle node term" })
map({ "n" }, "<leader>tp", "<cmd>lua _python_toggle()<cr>", { desc = "Toggle python term" })

local trim_spaces = true
map("n", "<leader>ts", function()
	require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
end, { desc = "Send line to terminal" })

map({ "v", "x" }, "<leader>ts", function()
	require("toggleterm").send_lines_to_terminal("visual_selection", trim_spaces, { args = vim.v.count })
end, { desc = "Send selection to terminal" })

-- Move start/end with home row
map({ "n", "v" }, "gh", "_", { noremap = true, desc = "Go to start of line" })
map({ "n", "v" }, "gl", "$", { noremap = true, desc = "Go to end of line" })

-- Duplicate selection and comment original
map({ "n" }, "<leader>yc", "yy<cmd>normal gcc<CR>p", { noremap = true, desc = "Duplicate line and comment original" })
map({ "n" }, "yc", "yy<cmd>normal gcc<CR>p", { noremap = true, desc = "Duplicate line and comment original" })
map({ "v" }, "<leader>yc", duplicate_and_comment, { noremap = true, desc = "Duplicate selection and comment original" })

-- Join lines reverse (J joins lines with space, gJ without)
map({ "n" }, "gK", "ddkPj", { noremap = true, desc = "Join lines reversed" })
map(
	"x",
	"gK",
	"<esc><cmd>keeppatterns '<,'>-global/$/normal! ddpkJ<cr>",
	{ noremap = true, desc = "Join lines reversed" }
)

-- Center cursor
map({ "n" }, "G", "Gzz", { noremap = true, desc = "Go to bottom and center" })
map({ "n" }, "n", "nzz", { noremap = true })
map({ "n" }, "N", "Nzz", { noremap = true })
map({ "n" }, "*", "*zz", { noremap = true })
map({ "n" }, "#", "#zz", { noremap = true })
map({ "n" }, "g*", "g*zz", { noremap = true })
map({ "n" }, "g#", "g#zz", { noremap = true })

-- Window
map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus up" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus down" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize left" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize right" })
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize up" })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize down" })

-- Comments
map("n", "<leader>/", function()
	return require("Comment.api").call("toggle.linewise." .. (vim.v.count == 0 and "current" or "count_repeat"), "g@$")()
end, { expr = true, desc = "Toggle comment" })
map(
	"x",
	"<leader>/",
	"<Esc><Cmd>lua require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())<CR>",
	{ desc = "Toggle comment blockwise" }
)
