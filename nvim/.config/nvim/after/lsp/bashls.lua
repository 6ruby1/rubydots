---@type vim.lsp.Config
return {
	filetypes = { "bash", "sh", "zsh" },
	root_markers = { ".git" },
	cmd = { "bash-language-server", "start" },
	settings = {
		bashIde = {
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
		},
	},
}
