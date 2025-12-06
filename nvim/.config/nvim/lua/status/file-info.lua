local Icon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color = require("mini.icons").get("file", filename)
	end,
	provider = function(self)
		return self.icon and (" " .. self.icon .. " ")
	end,
	hl = function(self)
		return self.icon_color
	end,
}

local FileType = {
	provider = function()
		return vim.bo.filetype
	end,
	hl = "StatusLine",
}

local FileNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	Icon,
	FileType,
}

return FileNameBlock
