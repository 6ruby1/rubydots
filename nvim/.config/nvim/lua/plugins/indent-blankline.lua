---@type LazySpec
return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {
			indent = {
				char = {
					"│",
					"¦",
					"┆",
					"┊",
				},
			},
			scope = {
				show_start = false,
				show_end = false,
				char = { "│" },
				highlight = { "CursorLineNr" },
			},
		},
	},
	-- {
	-- 	"shellRaining/hlchunk.nvim",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	config = function()
	-- 		require("hlchunk").setup({
	-- 			chunk = {
	-- 				enable = true,
	-- 				priority = 15,
	-- 				style = {
	-- 					{ fg = "#f7c67f" },
	-- 					-- 		{ fg = "#f16c75" },
	-- 				},
	-- 				use_treesitter = true,
	-- 				-- 	chars = {
	-- 				-- 		horizontal_line = "─",
	-- 				-- 		vertical_line = "│",
	-- 				-- 		left_top = "╭",
	-- 				-- 		left_bottom = "╰",
	-- 				-- 		right_arrow = ">",
	-- 				-- 	},
	-- 				textobject = "oc",
	-- 				-- 	max_file_size = 1024 * 1024,
	-- 				-- 	error_sign = true,
	-- 				-- 	-- animation related
	-- 				-- 	duration = 100,
	-- 				-- 	delay = 200,
	-- 				-- },
	-- 				-- indent = {
	-- 				-- 	enable = true,
	-- 				-- 	priority = 10,
	-- 				-- 	style = { vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui") },
	-- 				-- 	use_treesitter = false,
	-- 				-- 	chars = {
	-- 				-- 		"│",
	-- 				-- 		"¦",
	-- 				-- 		"┆",
	-- 				-- 		"┊",
	-- 				-- 	},
	-- 				-- 	ahead_lines = 5,
	-- 				-- 	delay = 100,
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
