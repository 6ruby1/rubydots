---@type LazySpec
return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	cmd = { "Yazi" },
	dependencies = {
		"folke/snacks.nvim",
	},
	---@type YaziConfig | {}
	opts = {
		open_for_directories = true,
		keymaps = {
			show_help = "<f1>",
		},
		highlight_groups = {
			hovered_buffer = { bg = none },
			hovered_buffer_in_same_directory = { bg = none },
		},
	},
	init = function()
		vim.g.loaded_netrwPlugin = 1 -- suppress netrw for open_for_directories
	end,
}
