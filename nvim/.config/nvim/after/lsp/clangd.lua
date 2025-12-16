---@type vim.lsp.Config
return {
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
		-- on_attach(client, bufnr)
	end,
}
