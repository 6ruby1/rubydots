-- Hint: use `:h <option>` to figure out the meaning if needed
vim.opt.clipboard = "unnamedplus" -- use system clipboard
-- vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.mouse = "a" -- allow the mouse to be used in nvim
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.virtualedit = "block" -- allow going past end of line in visual block mode
-- Tab
vim.opt.tabstop = 2 -- number of visual spaces per TAB
vim.opt.softtabstop = 2 -- number of spaces in tab when editing
vim.opt.shiftwidth = 2 -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of Python
vim.opt.autoindent = true -- automatically indent after "{" etc.
vim.opt.smartindent = true

-- UI config
vim.opt.number = true -- show absolute number
vim.opt.relativenumber = true -- add numbers to each line on the left side
vim.opt.cursorline = true -- highlight cursor line underneath the cursor horizontally
vim.opt.showtabline = 2 -- always show tabline
vim.opt.signcolumn = "yes" -- show sign column next to number column
vim.opt.showmode = false -- remove mode hint (--insert--)
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
-- vim.opt.termguicolors = true -- enable 24-bit RGB color in the TUI
vim.opt.confirm = true -- open save changes prompt
vim.opt.laststatus = 3 -- global statusline

vim.g.have_nerd_font = true

vim.o.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- enable above if wanted

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 1000

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
