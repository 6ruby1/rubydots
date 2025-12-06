local utils = require("heirline.utils")
local Spell = {
	condition = function()
		return vim.wo.spell
	end,
	provider = " ",
	hl = { bold = true, fg = utils.get_highlight("CursorLineNr").fg },
}

return Spell
