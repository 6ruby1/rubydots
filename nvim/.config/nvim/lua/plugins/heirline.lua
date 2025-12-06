---@type LazySpec
return {
	{
		"rebelot/heirline.nvim",
		dependencies = { "Zeioth/heirline-components.nvim", "neovim/nvim-lspconfig" },
		opts = function()
			local utils = require("heirline.utils")
			local conditions = require("heirline.conditions")
			local lib = require("heirline-components.all")

			return {
				tabline = { -- UI upper bar
					lib.component.tabline_conditional_padding(),
					require("status.bufline"),
					lib.component.fill({ hl = { bg = "#212337" } }),
					-- lib.component.tabline_tabpages(),
				},
				statusline = { -- UI statusbar
					hl = { fg = "fg", bg = "bg" },
					lib.component.mode(),
					lib.component.git_branch(),
					require("status.file-info"),
					lib.component.git_diff(),
					lib.component.fill(),
					lib.component.cmd_info({}),
					lib.component.fill(),
					lib.component.compiler_state(),
					lib.component.virtual_env(),
					-- lib.component.nav({ scrollbar = false, surround = { separator = "right" } }),
					-- lib.component.mode({ surround = { separator = "right" } }),
					require("status.lsp-info"),
					require("status.spell"),
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
