local M = {}

M.fill = { provider = "%=" }
M.space = { provider = " " }

M.bufline = require("status.bufline")
M.cmd_info = require("status.cmd-info")
M.file = require("status.file-info")
M.git = require("status.git")
M.lsp = require("status.lsp-info")
M.ruler = require("status.ruler")
M.spell = require("status.spell")

return M
