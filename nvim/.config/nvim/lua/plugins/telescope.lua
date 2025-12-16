---@type LazySpec
return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"LinArcX/telescope-env.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					-- condition used to determine if installation/loading required
					return vim.fn.executable("make") == 1
				end,
			},
			{
				"jvgrootveld/telescope-zoxide",
				config = function() end,
			},
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					-- preview = { treesitter = false },
					color_devicons = true,
					sorting_strategy = "ascending",
					-- border = {
					-- 	prompt = { 1, 1, 1, 1 },
					-- 	results = { 1, 1, 1, 1 },
					-- 	preview = { 1, 1, 1, 1 },
					-- },
					borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					--
					-- 	prompt = { " ", " ", "─", "│", "│", " ", "─", "└" },
					-- 	results = { "─", " ", " ", "│", "┌", "─", " ", "│" },
					-- 	preview = { "─", "│", "─", "│", "┬", "┐", "┘", "┴" },
					-- },
					layout_strategy = "horizontal",
					layout_config = {
						-- horizontal = {
						height = 0.99,
						width = 0.99,
						-- },
						-- center = {
						-- height = 0.8,
						preview_cutoff = 10,
						prompt_position = "top",
						-- width = 0.8,
						-- },
						-- 	height = 100,
						-- 	width = 100,
						-- 	prompt_position = "top",
						-- 	preview_cutoff = 40,
					},

					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--trim", -- remove indentation is search res
						"--hidden", -- show hidden files
						"--no-ignore", -- show .gitignore files
						"--follow", -- follow symlinks
					},
					-- Prefer fd for find_files and include hidden files and follow symlinks
					find_command = { "fd", "--type", "f", "--hidden", "--follow", "--exclude", ".git" },
					-- Reduce accidental broad matches from patterns you don't want to ignore here
					file_ignore_patterns = {
						"node_modules",
						"target",
						".git/",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						no_ignore = true,
					},
					live_grep = {
						-- vimgrep_arguments already configured above
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "env")
			pcall(require("telescope").load_extension, "zoxide")
		end,
	},
}
