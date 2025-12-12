local function has_words_before()
	local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

---@type function?, function?
local icon_provider, hl_provider

local function get_kind_icon(CTX)
	-- Evaluate icon provider
	if not icon_provider then
		local _, mini_icons = pcall(require, "mini.icons")
		if _G.MiniIcons then
			icon_provider = function(ctx)
				local is_specific_color = ctx.kind_hl and ctx.kind_hl:match("^HexColor") ~= nil
				if ctx.item.source_name == "LSP" then
					local icon, hl = mini_icons.get("lsp", ctx.kind or "")
					if icon then
						ctx.kind_icon = icon
						if not is_specific_color then
							ctx.kind_hl = hl
						end
					end
				elseif ctx.item.source_name == "Path" then
					ctx.kind_icon, ctx.kind_hl =
						mini_icons.get(ctx.kind == "Folder" and "directory" or "file", ctx.label)
				elseif ctx.item.source_name == "Snippets" then
					ctx.kind_icon, ctx.kind_hl = mini_icons.get("lsp", "snippet")
				end
			end
		end
		if not icon_provider then
			local lspkind_avail, lspkind = pcall(require, "lspkind")
			if lspkind_avail then
				icon_provider = function(ctx)
					if ctx.item.source_name == "LSP" then
						local icon = lspkind.symbolic(ctx.kind, { mode = "symbol" })
						if icon then
							ctx.kind_icon = icon
						end
					elseif ctx.item.source_name == "Snippets" then
						local icon = lspkind.symbolic("Snippet", { mode = "symbol" })
						if icon then
							ctx.kind_icon = icon
						end
					end
				end
			end
		end
		if not icon_provider then
			icon_provider = function() end
		end
	end
	-- Evaluate highlight provider
	if not hl_provider then
		local highlight_colors_avail, highlight_colors = pcall(require, "nvim-highlight-colors")
		if highlight_colors_avail then
			local kinds
			hl_provider = function(ctx)
				if not kinds then
					kinds = require("blink.cmp.types").CompletionItemKind
				end
				if ctx.item.kind == kinds.Color then
					local doc = vim.tbl_get(ctx, "item", "documentation")
					if doc then
						local color_item = highlight_colors_avail
							and highlight_colors.format(doc, { kind = kinds[kinds.Color] })
						if color_item and color_item.abbr_hl_group then
							if color_item.abbr then
								ctx.kind_icon = color_item.abbr
							end
							ctx.kind_hl = color_item.abbr_hl_group
						end
					end
				end
			end
		end
		if not hl_provider then
			hl_provider = function() end
		end
	end
	-- Call resolved providers
	icon_provider(CTX)
	hl_provider(CTX)
	-- Return text and highlight information
	return { text = CTX.kind_icon .. CTX.icon_gap, highlight = CTX.kind_hl }
end

---@type LazySpec
return {
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"eldritch-theme/eldritch.nvim",
			"MahanRahmati/blink-nerdfont.nvim",
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "nerdfont" },
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
					lua = { inherit_defaults = true, "lazydev" },
				},
				providers = {
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100, -- increase priority
					},
					nerdfont = {
						module = "blink-nerdfont",
						name = "Nerd Fonts",
						score_offset = 15, -- Tune by preference
						opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
					},
					lsp = { fallbacks = {} },
				},
			},
			keymap = {
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-N>"] = { "select_next", "show" },
				["<C-P>"] = { "select_prev", "show" },
				["<C-J>"] = { "select_next", "fallback" },
				["<C-K>"] = { "select_prev", "fallback" },
				["<C-U>"] = { "scroll_documentation_up", "fallback" },
				["<C-D>"] = { "scroll_documentation_down", "fallback" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = {
					"select_next",
					"snippet_forward",
					function(cmp)
						if has_words_before() or vim.api.nvim_get_mode().mode == "c" then
							return cmp.show()
						end
					end,
					"fallback",
				},
				["<S-Tab>"] = {
					"select_prev",
					"snippet_backward",
					function(cmp)
						if vim.api.nvim_get_mode().mode == "c" then
							return cmp.show()
						end
					end,
					"fallback",
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			completion = {
				keyword = { range = "prefix" },
				list = { selection = { preselect = false, auto_insert = true } },
				menu = {
					auto_show = function(ctx)
						return ctx.mode ~= "cmdline"
					end,
					min_width = 15,
					border = "none",
					draw = {
						-- treesitter = { "lsp" },
						components = {
							kind_icon = {
								-- text = function(ctx)
								-- 	return get_kind_icon(ctx).text
								-- end,
								-- highlight = function(ctx)
								-- 	return get_kind_icon(ctx).highlight
								-- end,
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
						columns = {
							{ "kind_icon", "label", gap = 1 },
							{ "label_description" },
						},
					},
				},
				accept = {
					auto_brackets = { enabled = true },
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 0,
					window = {
						min_width = 10,
						border = "bold",
					},
					treesitter_highlighting = true,
				},
			},
			cmdline = {
				enabled = false,
				keymap = {
					["<End>"] = { "hide", "fallback" },
				},
				completion = {
					ghost_text = { enabled = false },
				},
			},
			signature = {
				enabled = true,
				window = {
					min_width = 10,
					border = "rounded",
					treesitter_highlighting = true,
					-- show_documentation = true,
				},
			},
		},
	},
}
