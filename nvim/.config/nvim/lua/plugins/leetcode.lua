---@type LazySpec
return {
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
		dependencies = {
			-- include a picker of your choice, see picker section for more details
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			lang = "cpp",
			storage = {
				home = "~/dev/leetcode.nvim/data",
				cache = "~/dev/leetcode.nvim/cache",
			},
			picker = { provider = "telescope" },
			hooks = {
				["enter"] = {
					function()
						vim.api.nvim_set_hl(0, "NormalFloat", { bg = none })
					end,
				},
			},
		},
	},
}
