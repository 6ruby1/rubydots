---@type LazySpec
return {
	{
		"rebelot/heirline.nvim",
		dependencies = { "Zeioth/heirline-components.nvim", "neovim/nvim-lspconfig" },
		opts = function()
			local utils = require("heirline.utils")
			local conditions = require("heirline.conditions")
			local lib = require("heirline-components.all")
			local components = require("status")

			return {
				tabline = { -- UI upper bar
					lib.component.tabline_conditional_padding(),
					components.bufline,
					lib.component.fill({ hl = { bg = "#212337" } }),
					-- lib.component.tabline_tabpages(),
				},
				statusline = { -- UI statusbar
					hl = { fg = "fg", bg = "bg" },
					lib.component.mode(),
					components.git,
					-- lib.component.git_branch(),
					components.file,
					-- lib.component.git_diff(),
					components.fill,
					components.cmd_info,
					components.fill,
					-- lib.component.compiler_state(),
					lib.component.virtual_env(),
					components.ruler,
					components.lsp,
					components.spell,
				},
				statuscolumn = { -- UI left column
					init = function(self)
						self.bufnr = vim.api.nvim_get_current_buf()
					end,
					lib.component.foldcolumn(),
					lib.component.signcolumn(),
					lib.component.numbercolumn(),
				} or nil,
			}
		end,
		config = function(_, opts)
			local heirline = require("heirline")
			local heirline_components = require("heirline-components.all")

			-- Setup
			heirline_components.init.subscribe_to_events()
			heirline.load_colors(heirline_components.hl.get_colors())
			heirline.setup(opts)
		end,
	},
}
