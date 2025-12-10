---@type LazySpec
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			-- WARN: Add new parsers to install AND autocmd

			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})
			ts.install({
				-- INFO: parsers here
				"bash",
				"c",
				"cpp",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"rust",
				"javascript",
				"typescript",
				"jsx",
				"jsdoc",
				"java",
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					-- INFO: AND parsers here
					"bash",
					"c",
					"cpp",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
					"rust",
					"javascript",
					"typescript",
					"jsx",
					"jsdoc",
					"java",
				},
				callback = function()
					-- syntax highlighting, provided by Neovim
					vim.treesitter.start()
					-- folds, provided by Neovim
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					-- indentation, provided by nvim-treesitter
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
	},
}
