return {
	{
		"liaozixin/nvim-cpptools",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "cpp" },
		keys = {
			{
				"<leader>lnn",
				"<cmd>lua require('cpptool').create_file()",
				mode = "n",
				ft = "cpp",
				desc = "Create cpp file",
			},

			{
				"<leader>lnf",
				"<cmd>lua require('cpptool').create_func_def()",
				mode = "n",
				ft = "cpp",
				desc = "Create function def",
			},
		},
	},
}
