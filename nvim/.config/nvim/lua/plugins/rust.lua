vim.g.rustaceanvim = {
	-- Plugin configuration
	tools = {
		enable_clippy = true,
	},
	-- LSP configuration
	server = {
		default_settings = {
			-- rust-analyzer language server configuration
			["rust-analyzer"] = {
				assist = {
					importEnforceGranularity = true,
					importPrefix = "crate",
				},
				cargo = {
					allFeatures = true,
				},
				checkOnSave = true,
				--       {
				-- 	command = "clippy",
				-- },
				inlayHints = { locationLinks = true },
				diagnostics = {
					enable = true,
					experimental = {
						enable = true,
					},
				},
			},
		},
		standalone = true,
	},
}

return {
	{
		"mrcjkb/rustaceanvim",
		dependencies = { "nvim-neotest/neotest" },
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
		keys = {
			{
				"<leader>a",
				function()
					vim.cmd.RustLsp("codeAction")
				end,
				mode = "n",
				ft = "rust",
				desc = "Rust codeAction",
				silent = true,
				buffer = 0,
			},
			{
				"K",
				function()
					vim.cmd.RustLsp({ "hover", "actions" })
				end,
				mode = "n",
				ft = "rust",
				desc = "hover",
				silent = true,
				buffer = 0,
			},
			{
				"<leader>ld",
				function()
					vim.cmd.RustLsp("renderDiagnostic")
				end,
				mode = "n",
				ft = "rust",
				desc = "Render Diagnostic",
				silent = true,
				buffer = 0,
			},
			{
				"<leader>lgr",
				function()
					vim.cmd.RustLsp("relatedDiagnostics")
				end,
				mode = "n",
				ft = "rust",
				desc = "Jump to related diagnostics",
				silent = true,
				buffer = 0,
			},
			{
				"<leader>lgx",
				function()
					vim.cmd.RustLsp("openDocs")
				end,
				mode = "n",
				ft = "rust",
				desc = "Open docs.rs url",
				silent = true,
				buffer = 0,
			},
			{
				"<leader>lv",
				function()
					vim.cmd.RustLsp("openCargo")
				end,
				mode = "n",
				ft = "rust",
				desc = "Open Cargo.toml",
				silent = true,
				buffer = 0,
			},
			{
				"<leader>lxt",
				function()
					vim.cmd.RustLsp("testables")
				end,
				mode = "n",
				ft = "rust",
				desc = "Execute testables",
				silent = true,
				buffer = 0,
			},
			{
				"<leader>lxr",
				function()
					vim.cmd.RustLsp("runnables")
				end,
				mode = "n",
				ft = "rust",
				desc = "Execute runnables",
				silent = true,
				buffer = 0,
			},
		},
	},
}
