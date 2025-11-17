local map = vim.keymap.set

local function git_files()
	builtin.find_files({ no_ignore = true })
end

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

-- [F]ind
local builtin = require("telescope.builtin")
map({ "n" }, "<leader>ff", builtin.find_files, { desc = "files" })
map({ "n" }, "<leader>fw", builtin.live_grep, { desc = "live grep" })
map({ "n" }, "<leader>fg", git_files, { desc = "git files" })
map({ "n" }, "<leader>fb", builtin.buffers, { desc = "buffers" })
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
map({ "n" }, "<leader>fe", "<cmd>Telescope env<cr>", { desc = "env variables" })
map({ "n" }, "<leader>fa", require("actions-preview").code_actions, { desc = "code actions" })

-- [U]I
map({ "n" }, "<leader>uC", "<Cmd>CccHighlighterToggle<CR>", { desc = "Toggle color highlight" })
map({ "n" }, "<leader>uf", toggle_autoformat_buff, { desc = "Toggle autoformat (buffer)" })
map({ "n" }, "<leader>uF", toggle_autoformat_global, { desc = "Toggle autoformat (global)" })

-- [L]anguage
map({ "n" }, "<leader>lr", vim.lsp.buf.rename, { desc = "Rename current symbol" })
map({ "n", "v", "x" }, "<leader>lf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
map({ "n" }, "<leader>cc", "<Cmd>CccConvert<CR>", { desc = "convert color" })
map({ "n" }, "<leader>cp", "<Cmd>CccPick<CR>", { desc = "pick color" })

-- Misc
map({ "n" }, "<leader>w", "<Cmd>update<CR>", { desc = "Write the current buffer." })
map({ "n" }, "<leader>q", "<Cmd>:quit<CR>", { desc = "Quit the current buffer." })
map({ "n" }, "<leader>Q", "<Cmd>:wqa<CR>", { desc = "Quit all buffers and write." })
map({ "n" }, "<Esc>", "<cmd>nohlsearch<CR>")
map({ "n", "v", "x" }, "<leader>o", "<Cmd>source %<CR>", { desc = "Source " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>O", "<Cmd>restart<CR>", { desc = "Restart vim." })
map({ "n", "v", "x" }, "<leader>n", ":norm ", { desc = "Enter norm command" })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })
map({ "n" }, "<leader>r", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "Search and replace word under cursor" })
vim.keymap.set(
	"n",
	"g/",
	":vimgrep /<C-R>//j %<CR>|:cw<CR>",
	{ noremap = true, silent = true, desc = "Populate quickfix with search results" }
)

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

-- Move start/end with home row
map({ "n", "v" }, "gh", "_", { noremap = true, desc = "Go to start of line" })
map({ "n", "v" }, "gl", "$", { noremap = true, desc = "Go to end of line" })

-- Duplicate selection and comment original
map({ "n" }, "yc", "yy<cmd>normal gcc<CR>p", { noremap = true, desc = "Duplicate line and comment original" })
map({ "v" }, "yc", duplicate_and_comment, { noremap = true, desc = "Duplicate selection and comment original" })

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
