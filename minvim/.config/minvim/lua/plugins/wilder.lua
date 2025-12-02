---@type LazySpec
return {
	{
		"nixprime/cpsm",
		build = "./install.sh",
	},
	{
		"gelguy/wilder.nvim",
		dependencies = { "nixprime/cpsm", "romgrk/fzy-lua-native", "kyazdani42/nvim-web-devicons" },
		config = function()
			local wilder = require("wilder")
			wilder.setup({ modes = { ":", "/", "?" } })

			wilder.set_option("pipeline", {
				wilder.debounce(10),
				wilder.branch(
					wilder.python_file_finder_pipeline({
						file_command = function(ctx, arg)
							if string.find(arg, ".") ~= nil then
								return { "fd", "-tf", "-H" }
							else
								return { "fd", "-tf" }
							end
						end,
						dir_command = { "fd", "-td" },
						filters = { "fuzzy_filter" },
					}),
					wilder.substitute_pipeline({
						pipeline = wilder.python_search_pipeline({
							skip_cmdtype_check = true,
							pattern = wilder.python_fuzzy_pattern(),
							sorter = wilder.python_difflib_sorter(),
							engine = "re",
						}),
					}),
					wilder.cmdline_pipeline({
						fuzzy = 2,
						fuzzy_filter = wilder.lua_fzy_filter(),
					}),
					{
						wilder.check(function(ctx, x)
							return x == ""
						end),
						wilder.history(),
					},
					wilder.python_search_pipeline({
						pattern = wilder.python_fuzzy_pattern({
							start_at_boundary = 0,
						}),
					})
				),
			})

			local highlighters = {
				wilder.python_pcre2_highlighter(), -- requires python pcre2
				wilder.lua_fzy_highlighter(),  -- requires fzy-lua-native vim plugin
			}

			local wildmenu_renderer = wilder.wildmenu_renderer({
				highlighter = highlighters,
				highlights = {
					accent = wilder.make_hl(
						"WilderAccent",
						"Pmenu",
						{ { a = 1 }, { a = 1 }, { foreground = "#7081d0", italic = true, underline = true } }
					),
					selected = wilder.make_hl(
						"WilderWildmenuSelectedAccent",
						"SignColumn",
						{ { a = 1 }, { a = 1 }, { foreground = "#7081d0", bold = true } }
					),
				},
				right = { "", wilder.wildmenu_index() },
			})

			-- local substitute_renderer = wilder.wildmenu_renderer({
			-- 	highlighter = highlighters,
			-- 	highlights = {
			-- 		accent = wilder.make_hl(
			-- 			"WilderSubstituteAccent",
			-- 			"Pmenu",
			-- 			{ { a = 1 }, { a = 1 }, { foreground = "#f16c75", italic = true, underline = true } }
			-- 		),
			-- 		selected = wilder.make_hl(
			-- 			"WilderWildmenuSubstituteSelectedAccent",
			-- 			"SignColumn",
			-- 			{ { a = 1 }, { a = 1 }, { foreground = "#f16c75", bold = true, reverse = true } }
			-- 		),
			-- 	},
			-- 	right = { "", wilder.wildmenu_index() },
			-- })

			wilder.set_option(
				"renderer",
				wilder.renderer_mux({
					[":"] = wildmenu_renderer,
					["/"] = wildmenu_renderer,
					substitute = wildmenu_renderer,
				})
			)
		end,
	},
}
