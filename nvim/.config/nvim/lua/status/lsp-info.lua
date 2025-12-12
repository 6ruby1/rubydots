local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local diagnostic_hl = {
	error = utils.get_highlight("DiagnosticSignError"),
	warn = utils.get_highlight("DiagnosticSignWarn"),
	hint = utils.get_highlight("DiagnosticSignHint"),
	info = utils.get_highlight("DiagnosticSignInfo"),
	none = utils.get_highlight("StatusLine"),
}

local function has_diagnostic()
	for _, value in pairs({
		#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
		#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
		#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }),
		#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
	}) do
		if value > 0 then
			return true
		end
	end
	return false
end

local Info = utils.surround({ " ", " " }, nil, {
	provider = "󰒓",
	hl = function()
		return (#vim.lsp.get_clients({ bufnr = 0 }) > 0 and "StatusLine") or diagnostic_hl.error
	end,
	on_click = {
		name = "heirline_lsp",
		callback = function()
			vim.schedule(vim.cmd.LspInfo)
		end,
	},
})

local Diagnostics = {
	condition = has_diagnostic,
	init = function(self)
		self.icons = false -- Enable/disable diagnostic icons
		self.error_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR]
		self.warn_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN]
		self.info_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO]
		self.hint_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT]
	end,
	update = { "DiagnosticChanged", "BufEnter" },
	on_click = {
		name = "heirline_lsp_diagnostics",
		callback = function()
			if pcall(require, "telescope.builtin") then
				require("telescope.builtin").diagnostics()
			else
				vim.notify("Telescope diagnostics unavailable", vim.log.levels.WARN)
			end
			-- vim.schedule(vim.cmd.LspInfo)
		end,
	},

	{
		provider = function(self)
			-- return (self.error_icon .. self.errors .. " ")
			return (self.icons and self.error_icon or "") .. self.errors .. " "
		end,
		hl = function(self)
			if self.errors > 0 then
				return diagnostic_hl.error
			else
				return diagnostic_hl.none
			end
		end,
	},
	{
		provider = function(self)
			-- return (self.warn_icon .. self.warnings .. " ")
			return (self.icons and self.warn_icon or "") .. self.warnings .. " "
		end,
		hl = function(self)
			if self.warnings > 0 then
				return diagnostic_hl.warn
			else
				return diagnostic_hl.none
			end
		end,
	},
	{
		provider = function(self)
			-- return self.hints > 0 and (self.hint_icon .. self.hints)
			return (self.icons and self.hint_icon or "") .. self.hints .. " "
		end,
		hl = function(self)
			if self.hints > 0 then
				return diagnostic_hl.hint
			else
				return diagnostic_hl.none
			end
		end,
	},
	{
		provider = function(self)
			-- return self.info > 0 and (self.info_icon .. self.info .. " ")
			return self.info > 0 and ((self.icons and self.info_icon or "") .. self.info .. " ")
		end,

		hl = function(self)
			if self.info > 0 then
				return diagnostic_hl.info
			else
				return diagnostic_hl.none
			end
		end,
	},
}

local Indicator = utils.surround({ "", " " }, nil, {
	provider = " ", -- whitespace to add coloured bar
	hl = function(self)
		-- TODO: use mode color as fallback instead of cyan!
		if not conditions.lsp_attached() or self.errors > 0 then
			return { bg = diagnostic_hl.error.fg }
		elseif self.warnings > 0 then
			return { bg = diagnostic_hl.warn.fg }
		elseif self.hints > 0 then
			return { bg = diagnostic_hl.hint.fg }
		elseif self.info > 0 then
			return { bg = diagnostic_hl.info.fg }
		else
			return { bg = "cyan" }
		end
	end,
})

local Lsp = {
	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	end,
	update = {
		"LspAttach",
		"LspDetach",
		"BufEnter",
		"DiagnosticChanged",
		"FileType",
		"VimResized",

		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
	Info,
	Indicator,
	Diagnostics,
}

return Lsp
