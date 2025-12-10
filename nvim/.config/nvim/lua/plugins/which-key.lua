---@type LazySpec
return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = { -- Lazy keymap table
			scroll_up = "<c-up>",
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		opts = {
			win = {
				width = { min = 30, max = 60 },
				height = { min = 4, max = 0.75 },
				padding = { 0, 1 },
				col = 1,
				row = -1,
				border = "single",
				title = true,
				title_pos = "left",
			},
			layout = {
				width = { min = 30 },
			},
			keys = { -- which-key keymap table
				scroll_down = "<a-down>",
				scroll_up = "<a-up>",
			},
			icons = {
				colors = true, -- (1 = use mini.icon colors)
				keys = { -- which-key key icons
					Up = " ",
					Down = " ",
					Left = " ",
					Right = " ",
					C = "󰘴 ",
					M = "󰘵 ",
					D = "󰘳 ",
					S = "󰘶 ",
					CR = "󰌑 ",
					Esc = "󱊷 ",
					ScrollWheelDown = "󱕐 ",
					ScrollWheelUp = "󱕑 ",
					NL = "󰌑 ",
					BS = "󰁮",
					Space = "󱁐 ",
					Tab = "󰌒 ",
					F1 = "󱊫",
					F2 = "󱊬",
					F3 = "󱊭",
					F4 = "󱊮",
					F5 = "󱊯",
					F6 = "󱊰",
					F7 = "󱊱",
					F8 = "󱊲",
					F9 = "󱊳",
					F10 = "󱊴",
					F11 = "󱊵",
					F12 = "󱊶",
				},
			},
		},
	},
}
