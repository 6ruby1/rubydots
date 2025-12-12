---@type LazySpec
return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	cmd = { "Yazi" },
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	---@type YaziConfig | {}
	opts = {
		config_home = "~/.config/yazi/nvim-config",
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
