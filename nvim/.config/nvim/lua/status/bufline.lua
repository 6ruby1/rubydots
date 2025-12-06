local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local Icon = {
	provider = function(self)
		return self.icon and (" " .. self.icon .. " ")
	end,
	hl = function(self)
		if self.is_active then
			return "white"
		end
		return self.icon_color
	end,
}

local FileName = {
	provider = function(self)
		local filename = self.filename
		filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
		return filename
	end,
	hl = function(self)
		return { bold = self.is_active or self.is_visible, italic = true }
	end,
}

local FileModified = {
	condition = function(self)
		return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
	end,
	provider = "+",
	hl = function(self)
		if self.is_active then
			return "white"
		end
		return self.icon_color
	end,
}

local FileReadOnly = {
	condition = function(self)
		return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
			or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
	end,
	provider = " ",
	hl = "Error",
}

local ActiveFileName = {
	condition = function(self)
		return self.is_active
	end,
	hl = "white",
	FileName,
}

local BufNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(self.bufnr)
		self.extension = vim.fn.fnamemodify(self.filename, ":e")
		self.icon, self.icon_color = require("mini.icons").get("file", self.filename)
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
	Icon,
	FileModified,
	ActiveFileName,
	FileReadOnly,
}

local BufferLine = {
	utils.make_buflist(BufNameBlock, { provider = "", hl = "StatusLine" }, { provider = "", hl = "StatusLine" }),
}

return BufferLine
