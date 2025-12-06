---@type LazySpec
return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = {
		"folke/snacks.nvim",
	},
	keys = {
		{
			"<leader>e",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},
		{
			"<leader>xw",
			"<cmd>Yazi cwd<cr>",
			desc = "Open the file manager in nvim's working directory",
		},
		{
			"<c-up>",
			"<cmd>Yazi toggle<cr>",
			desc = "Resume the last yazi session",
		},
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
