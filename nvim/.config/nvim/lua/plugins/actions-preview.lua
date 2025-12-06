---@type LazySpec
return {
	"aznhe21/actions-preview.nvim",
	opts = {
		backend = { "telescope" },
		extensions = { "env" },
		telescope = vim.tbl_extend("force", require("telescope.themes").get_dropdown(), {}),
	},
}
