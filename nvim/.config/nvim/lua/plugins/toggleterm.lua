return {
	{ "psliwka/termcolors.nvim" },
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				start_in_insert = true,
				float_opts = {
					border = "curved",
				},
				-- highlights = {
				-- 	-- highlights which map to a highlight group name and a table of it's values
				-- 	-- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
				-- 	Normal = {
				-- 		link = "Pmenu",
				-- 	},
				-- 	NormalFloat = {
				-- 		link = "Normal",
				-- 	},
				-- 	FloatBorder = {
				-- 		guifg = "<VALUE-HERE>",
				-- 		guibg = "<VALUE-HERE>",
				-- 	},
				-- },
			})
		end,
	},
}
