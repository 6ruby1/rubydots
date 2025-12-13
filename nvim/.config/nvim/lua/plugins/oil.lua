return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		dependencies = { "nvim-mini/mini.nvim" },
		lazy = false,
		config = function()
			require("oil").setup({
				columns = { "icon" },
				view_options = { show_hidden = true },
			})
			require("which-key").add({
				{ "-", "<cmd>Oil<cr>", desc = "Open parent directory", mode = "n" },
			})
		end,
	},
}
