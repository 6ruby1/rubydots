local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local hl_purple = utils.get_highlight("WinSeparator")

local Branch = {
	provider = function(self)
		return self.status_dict.head
	end,
	hl = { bold = true },
}

local Add = {
	provider = function(self)
		local count = self.status_dict.added or 0
		return count > 0 and count
	end,
	hl = "GitSignsAdd",
}

local Del = {
	provider = function(self)
		local count = self.status_dict.removed or 0
		return count > 0 and count
	end,
	hl = "GitSignsDelete",
}

local Change = {
	provider = function(self)
		local count = self.status_dict.changed or 0
		return count > 0 and count
	end,
	hl = "GitSignsChange",
}

local Diff = {
	condition = function(self)
		return self.has_changes
	end,
	hl = { bold = true },
	{ provider = "|" },
	Add,
	Change,
	Del,
}

local Git = utils.surround({ "", " " }, nil, {
	condition = conditions.is_git_repo,
	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,
	hl = { fg = hl_purple.fg },
	on_click = {
		name = "heirline_branch",
		callback = function()
			if pcall(require, "telescope") then
				require("telescope.builtin").git_branches({ use_file_path = true })
			end
		end,
	},
	update = {
		"User",
		pattern = { "GitSignsUpdate", "GitSignsChanged", "MiniDiffUpdated" },
	},
	Branch,
	Diff,
})

return Git
