---@type LazySpec
return {
	{
		"rebelot/heirline.nvim",
		dependencies = { "Zeioth/heirline-components.nvim" },
		opts = function()
			local utils = require("heirline.utils")
			local conditions = require("heirline.conditions")
			local lib = require("heirline-components.all")

			local TablineBufnr = {
				provider = function(self)
					return tostring(self.bufnr) .. ". "
				end,
				hl = "Comment",
			}

			local FileIcon = {
				init = function(self)
					local filename = self.filename
					local extension = vim.fn.fnamemodify(filename, ":e")
					self.icon, self.icon_color =
						-- require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
						require("mini.icons").get("file", filename)
				end,
				provider = function(self)
					return self.icon and (" " .. self.icon .. " ")
				end,
				hl = function(self)
					return self.icon_color
				end,
			}

			-- we redefine the filename component, as we probably only want the tail and not the relative path
			local TablineFileName = {
				provider = function(self)
					-- self.filename will be defined later, just keep looking at the example!
					local filename = self.filename
					filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
					return filename
				end,
				hl = function(self)
					return { bold = self.is_active or self.is_visible, italic = true }
				end,
			}

			-- this looks exactly like the FileFlags component that we saw in
			-- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
			-- also, we are adding a nice icon for terminal buffers.
			local TablineFileFlags = {
				{
					condition = function(self)
						return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
					end,
					provider = "",
					hl = { fg = "#ebfafa" },
				},
				{
					condition = function(self)
						return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
							or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
					end,
					provider = function(self)
						if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
							return "  "
						else
							return ""
						end
					end,
					hl = { fg = "orange" },
				},
			}

			-- Here the filename block finally comes together
			local TablineFileNameBlock = {
				init = function(self)
					self.filename = vim.api.nvim_buf_get_name(self.bufnr)
				end,
				hl = function(self)
					if self.is_active then
						return "TabLineSel"
						-- why not?
						-- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
						--     return { fg = "gray" }
					else
						return "TabLine"
					end
				end,
				on_click = {
					callback = function(_, minwid, _, button)
						if button == "m" then -- close on mouse middle click
							vim.schedule(function()
								vim.api.nvim_buf_delete(minwid, { force = false })
							end)
						else
							vim.api.nvim_win_set_buf(0, minwid)
						end
					end,
					minwid = function(self)
						return self.bufnr
					end,
					name = "heirline_tabline_buffer_callback",
				},
				-- TablineBufnr,
				FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
				-- TablineFileName,
				TablineFileFlags,
			}

			-- a nice "x" button to close the buffer
			local TablineCloseButton = {
				condition = function(self)
					return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
				end,
				{ provider = "" },
				{
					provider = "",
					hl = { fg = "gray" },
					on_click = {
						callback = function(_, minwid)
							vim.schedule(function()
								vim.api.nvim_buf_delete(minwid, { force = false })
								vim.cmd.redrawtabline()
							end)
						end,
						minwid = function(self)
							return self.bufnr
						end,
						name = "heirline_tabline_close_buffer_callback",
					},
				},
			}

			-- The final touch!
			local TablineBufferBlock = utils.surround({ "", "" }, function(self)
				if self.is_active then
					return utils.get_highlight("TabLineSel").bg
				else
					return utils.get_highlight("TabLine").bg
				end
			end, { TablineFileNameBlock }) -- <- could put TablineCloseButton

			-- and here we go
			local BufferLine = utils.make_buflist(
				TablineBufferBlock,
				{ provider = "", hl = { fg = "gray" } }, -- left truncation, optional (defaults to "<")
				{ provider = "", hl = { fg = "gray" } } -- right trunctation, also optional (defaults to ...... yep, ">")
				-- by the way, open a lot of buffers and try clicking them ;)
			)

			local FileNameBlock = {
				-- let's first set up some attributes needed by this component and its children
				init = function(self)
					self.filename = vim.api.nvim_buf_get_name(0)
				end,
			}
			local FileType = {
				provider = function()
					return vim.bo.filetype
				end,
				hl = { fg = utils.get_highlight("StatusLine").fg },
			}
			FileNameBlock = utils.insert(FileNameBlock, FileIcon, FileType)
			return {
				tabline = { -- UI upper bar
					lib.component.tabline_conditional_padding(),
					BufferLine,
					-- lib.component.tabline_buffers(),
					lib.component.fill({ hl = { bg = "#212337" } }),
					-- lib.component.tabline_tabpages(),
				},
				statusline = { -- UI statusbar
					hl = { fg = "fg", bg = "bg" },
					lib.component.mode(),
					lib.component.git_branch(),
					-- lib.component.file_info(),
					FileNameBlock,
					lib.component.git_diff(),
					lib.component.diagnostics(),
					lib.component.fill(),
					lib.component.cmd_info({
						macro_recording = {
							icon = { kind = "MacroRecording", padding = { right = 1 } },
							condition = lib.condition.is_macro_recording,
							update = {
								"RecordingEnter",
								"RecordingLeave",
								callback = vim.schedule_wrap(function()
									vim.cmd.redrawstatus()
								end),
							},
						},
						search_count = {
							icon = { kind = "Search", padding = { right = 1 } },
							padding = { left = 1 },
							condition = lib.condition.is_hlsearch,
						},
						showcmd = {
							padding = { left = 1 },
							condition = lib.condition.is_statusline_showcmd,
						},
						surround = {
							separator = "center",
							color = "cmd_info_bg",
							condition = function()
								return lib.condition.is_hlsearch()
									or lib.condition.is_macro_recording()
									or lib.condition.is_statusline_showcmd()
							end,
						},
						condition = function()
							return vim.opt.cmdheight:get() == 0
						end,
						hl = lib.hl.get_attributes("cmd_info"),
					}),
					lib.component.fill(),
					lib.component.lsp(),
					lib.component.compiler_state(),
					lib.component.virtual_env(),
					lib.component.nav({ scrollbar = false, surround = { separator = "right" } }),
					lib.component.mode({ surround = { separator = "right" } }),
				},
				-- winbar = { -- UI breadcrumbs bar
				-- 	init = function(self)
				-- 		self.bufnr = vim.api.nvim_get_current_buf()
				-- 	end,
				-- 	fallthrough = false,
				-- 	-- Winbar for terminal, neotree, and aerial.
				-- 	{
				-- 		condition = function()
				-- 			return not lib.condition.is_active()
				-- 		end,
				-- 		{
				-- 			lib.component.neotree(),
				-- 			lib.component.compiler_play(),
				-- 			lib.component.fill(),
				-- 			lib.component.compiler_build_type(),
				-- 			lib.component.compiler_redo(),
				-- 			lib.component.aerial(),
				-- 		},
				-- 	},
				-- },
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
