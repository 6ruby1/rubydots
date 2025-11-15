vim.g.mapleader = " "
local map = vim.keymap.set

-- Language
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })

-- Fixme idk
map({ "n", "v", "x" }, "<leader>n", ":norm ", { desc = "ENTER NORM COMMAND." })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })

-- Window
map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus up" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus down" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize left" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize right" })
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize up" })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize down" })

-- Misc
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
