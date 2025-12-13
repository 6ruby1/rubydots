local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local SearchCount = {
	condition = function()
		return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
	end,
	init = function(self)
		local ok, search = pcall(vim.fn.searchcount)
		if ok and search.total then
			self.search = search
		end
	end,
	provider = function(self)
		local search = self.search
		return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
	end,
}

local MacroRec = {
	condition = function()
		return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
	end,
	provider = "󰻃 ",
	hl = { fg = utils.get_highlight("DiagnosticError").fg, bg = utils.get_highlight("DiagnosticError").bg, bold = true },
	{
		hl = "@keyword",
		utils.surround({ "[", "]" }, nil, {
			provider = function()
				return vim.fn.reg_recording()
			end,
			-- hl = { fg = "green", bold = true },
		}),
	},
	update = {
		"RecordingEnter",
		"RecordingLeave",
	},
}

local CmdInfo = {
	SearchCount,
	MacroRec,
}

return CmdInfo
