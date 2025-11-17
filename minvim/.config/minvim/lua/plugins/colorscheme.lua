---@type LazySpec
return {
	{
		"eldritch-theme/eldritch.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("eldritch").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- palette = "default", -- This option is deprecated. Use `vim.cmd[[colorscheme eldritch-dark]]` or `vim.cmd[[colorscheme eldritch-minimal]] instead.
				transparent = false, -- Enable this to disable setting the background color
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "dark", -- style for sidebars, see below
					floats = "dark", -- style for floating windows
				},
				sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
				hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
				dim_inactive = false, -- dims inactive windows, transparent must be false for this to work
				lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

				--- You can override specific color groups to use other groups or a hex color
				--- function will be called with a ColorScheme table
				---@param colors ColorScheme
				on_colors = function(colors) end,

				--- You can override specific highlights to use other groups or a hex color
				--- function will be called with a Highlights and ColorScheme table
				---@param highlights Highlights
				---@param colors ColorScheme
				on_highlights = function(highlights, colors)
					-- highlights.BlinkCmpDoc = { fg = colors.fg, bg = colors.bg }
					-- highlights.BlinkCmpDocBorder = { fg = colors.green, bg = none }
					-- highlights.BlinkCmpGhostText = { fg = colors.fg_gutter_light }
					-- highlights.BlinkCmpKindCodeium = { fg = colors.cyan, bg = colors.none }
					-- highlights.BlinkCmpKindCopilot = { fg = colors.cyan, bg = colors.none }
					-- highlights.BlinkCmpKindDefault = { fg = colors.fg_dark, bg = colors.none }
					-- highlights.BlinkCmpKindSupermaven = { fg = colors.cyan, bg = colors.none }
					-- highlights.BlinkCmpKindTabNine = { fg = colors.cyan, bg = colors.none }
					-- highlights.BlinkCmpLabel = { fg = colors.fg, bg = colors.none }
					-- highlights.BlinkCmpLabelDeprecated =
					-- 	{ fg = colors.fg_gutter, bg = colors.none, strikethrough = true }
					-- highlights.BlinkCmpLabelMatch = { fg = colors.bright_cyan, bg = colors.none }
					highlights.BlinkCmpMenu = { fg = colors.fg, bg = colors.bg }
					highlights.BlinkCmpMenuBorder = { fg = colors.magenta, bg = none }
					highlights.BlinkCmpMenuSelection = { fg = colors.pink, bg = colors.bg_highlight, bold = true }
					highlights.BlinkCmpScrollBarThumb = { bg = colors.magenta }
					highlights.BlinkCmpScrollBarGutter = { bg = colors.fg_gutter }
					highlights.BlinkCmpLabel = { fg = colors.cyan }
					-- highlights.BlinkCmpLabelDeprecated = { fg = x, bg = x }
					highlights.BlinkCmpLabelMatch = { fg = colors.pink }
					-- highlights.BlinkCmpLabelDetail = { fg = x, bg = x }
					highlights.BlinkCmpLabelDescription = { fg = colors.comment }
					-- highlights.BlinkCmpKind = { fg = x, bg = x }
					-- highlights.BlinkCmpSource = { fg = x, bg = x }
					-- highlights.BlinkCmpGhostText = { fg = x, bg = x }
					highlights.BlinkCmpDoc = { fg = colors.fg, bg = colors.bg }
					highlights.BlinkCmpDocBorder = { fg = colors.magenta, bg = none }
					highlights.BlinkCmpDocSeparator = { fg = colors.magenta, bg = colors.bg }
					highlights.BlinkCmpDocCursorLine = { bg = colors.bg_highlight }
					-- highlights.BlinkCmpSignatureHelp = { fg = colors.fg, bg = colors.bg }
					highlights.BlinkCmpSignatureHelpBorder = { fg = colors.green, bg = none }
					-- highlights.BlinkCmpSignatureHelpActiveParameter = { fg = x, bg = x }
				end,
			})
			vim.cmd([[colorscheme eldritch]])
		end,
	},
}
