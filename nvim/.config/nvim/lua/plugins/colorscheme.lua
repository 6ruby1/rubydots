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
					highlights.FloatBorder = { fg = colors.magenta2, bg = colors.none }
					-- See heirline.lua
					highlights.TabLine = { bg = colors.bg_dark }
					highlights.TabLineSel = { bg = colors.bg_highlight, underline = true }
					-- Set highlights for mini.icons
					highlights.MiniIconsAzure = { fg = colors.pink }
					highlights.MiniIconsBlue = { fg = colors.purple }
					highlights.MiniIconsCyan = { fg = colors.cyan }
					highlights.MiniIconsGreen = { fg = colors.green }
					highlights.MiniIconsGrey = { fg = colors.fg_dark }
					highlights.MiniIconsOrange = { fg = colors.orange }
					highlights.MiniIconsPurple = { fg = colors.pink }
					highlights.MiniIconsRed = { fg = colors.red }
					highlights.MiniIconsYellow = { fg = colors.yellow }
					-- Blink completion popup
					highlights.BlinkCmpMenu = { bg = colors.bg_dark }
					highlights.BlinkCmpMenuBorder = { fg = colors.comment, bg = colors.bg_dark }
					highlights.BlinkCmpMenuSelection =
						{ fg = colors.comment, bg = colors.bg_highlight, bold = true, underline = true }
					highlights.BlinkCmpScrollBarThumb = { bg = colors.magenta }
					highlights.BlinkCmpScrollBarGutter = { bg = colors.fg_gutter }
					highlights.BlinkCmpLabel = { fg = colors.fg_dark }
					highlights.BlinkCmpLabelMatch = { fg = colors.comment, underline = true, italic = true }
					highlights.BlinkCmpLabelDescription = { fg = colors.comment }
					highlights.BlinkCmpDoc = { fg = colors.fg, bg = colors.bg_dark }
					highlights.BlinkCmpDocBorder = { fg = colors.dark5, bg = colors.bg_dark }
					highlights.BlinkCmpDocSeparator = { fg = colors.red, bg = colors.bg_dark }
					highlights.BlinkCmpDocCursorLine = { bg = colors.bg_highlight }
					highlights.BlinkCmpSignatureHelpBorder = { fg = colors.pink, bg = colors.bg_dark, bold = true }
					highlights.BlinkCmpSignatureHelp = { fg = colors.fg_dark, bg = colors.bg_dark }
				end,
			})
			vim.cmd([[colorscheme eldritch]])
		end,
	},
}
