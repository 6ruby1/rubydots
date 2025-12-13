return {
	{
		"jiaoshijie/undotree",
		lazy = true,
		---@module 'undotree.collector'
		---@type UndoTreeCollector.Opts
		opts = {
			position = "left",
			window = {
				winblend = 10,
				border = "single",
			},
			keymaps = {
				j = "move_next",
				k = "move_prev",
				gj = "move2parent",
				J = "move_change_next",
				K = "move_change_prev",
				["<cr>"] = "action_enter",
				p = "enter_diffbuf",
				q = "quit",
			},
			ignore_filetype = {
				"terminal",
				"nofile",
				"undotree",
				"undotreeDiff",
				"qf",
				"mason",
				"lazy",
			},
		},
	},
}
