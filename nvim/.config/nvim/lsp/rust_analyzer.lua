return {
	settings = {
		["rust-analyzer"] = {
			assist = {
				importEnforceGranularity = true,
				importPrefix = "crate",
			},
			cargo = {
				allFeatures = true,
			},
			checkOnSave = {
				command = "clippy",
			},
			inlayHints = { locationLinks = false },
			diagnostics = {
				enable = true,
				experimental = {
					enable = true,
				},
			},
		},
	},
}
