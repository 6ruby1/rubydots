local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

---- Functions ----

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

---@alias diagnosticType "ERROR" | "WARN" | "INFO" | "HINT"
---@param type diagnosticType
local function DiagnosticByType(type)
	if not (type == "ERROR" or type == "WARN" or type == "INFO" or type == "HINT") then
		return { provider = "" }
	end

	return {
		provider = function(self)
			local show_zero = self.diagnostics[type].show_zero
			local count = self.diagnostics[type].count
			local icons_enabled = self.diagnostics.config.icons_enabled
			local icon = self.diagnostics[type].icon

			if show_zero or count > 0 then
				return (icons_enabled and icon or "") .. count .. " "
			else
				return ""
			end
		end,

		hl = function(self)
			if self.diagnostics[type].count > 0 then
				return self.diagnostics[type].hl
			else
				return self.diagnostics.config.hl_none
			end
		end,
	}
end

---- Components ----

local Info = utils.surround({ " ", " " }, nil, {
	provider = "󰒓",
	hl = function(self)
		local has_clients = #vim.lsp.get_clients({ bufnr = 0 }) > 0
		local hl_warn = self.diagnostics["WARN"].hl
		local hl_default = self.diagnostics.config.hl_none

		return (has_clients and hl_default) or hl_warn
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
	update = { "DiagnosticChanged", "BufEnter" },
	on_click = {
		name = "heirline_lsp_diagnostics",
		callback = function()
			if pcall(require, "trouble") then
				require("trouble").toggle("buf_diagnostics")
			else
				vim.notify("Trouble diagnostics unavailable", vim.log.levels.WARN)
			end
		end,
	},

	DiagnosticByType("ERROR"),
	DiagnosticByType("WARN"),
	DiagnosticByType("HINT"),
	DiagnosticByType("INFO"),
}

local Indicator = utils.surround({ "", " " }, nil, {
	provider = "|",
	hl = function(self)
		local is_attached = conditions.lsp_attached()
		local error = self.diagnostics["ERROR"]
		local warn = self.diagnostics["WARN"]
		local hint = self.diagnostics["HINT"]
		local info = self.diagnostics["INFO"]
		local hl_none = self.diagnostics.config.hl_none

		--[[
    Highlight precedence:
    1. LSP not available - orange
    2. Error - red
    3. Warn - orange
    4. Hint - green
    5. Info - yellow
    6. Fallback to "StatusLine"
    ]]

		if not is_attached then
			return warn.hl
		elseif error.count > 0 then
			return error.hl
		elseif warn.count > 0 then
			return warn.hl
		elseif hint.count > 0 then
			return hint.hl
		elseif info.count > 0 then
			return info.hl
		else
			return hl_none
		end
	end,
})

local Lsp = {
	init = function(self)
		self.diagnostics = {
			["ERROR"] = {
				count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
				icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR],
				hl = utils.get_highlight("DiagnosticSignError"),
				show_zero = true,
			},
			["WARN"] = {
				count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
				icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN],
				hl = utils.get_highlight("DiagnosticSignWarn"),
				show_zero = true,
			},
			["HINT"] = {
				count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }),
				icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT],
				hl = utils.get_highlight("DiagnosticSignHint"),
				show_zero = true,
			},
			["INFO"] = {
				count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
				icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO],
				hl = utils.get_highlight("DiagnosticSignInfo"),
				show_zero = false,
			},
			config = {
				icons_enabled = false,
				hl_none = utils.get_highlight("StatusLine"),
			},
		}
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
