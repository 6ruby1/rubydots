vim.api.nvim_set_hl(0, "OnYank", { fg = "#212337", bg = "#37f499" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ higroup = "OnYank", timeout = 150 })
	end,
})
