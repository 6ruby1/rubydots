local home = os.getenv("HOME")
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name
local mason_package_dir = home .. "/.local/share/nvim/mason/packages/"
local mason_share_dir = home .. "/.local/share/nvim/mason/share/"

local bundles = {
	-- vim.fn.glob("path/to/com.microsoft.java.debug.plugin-*.jar", 1)
	vim.fn.glob(mason_share_dir .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
}

local java_test_bundles = vim.split(vim.fn.glob(mason_share_dir .. "/java-test/extension/server/*.jar", 1), "\n")
local excluded = {
	"com.microsoft.java.test.runner-jar-with-dependencies.jar",
	"jacocoagent.jar",
}
for _, java_test_jar in ipairs(java_test_bundles) do
	local fname = vim.fn.fnamemodify(java_test_jar, ":t")
	if not vim.tbl_contains(excluded, fname) then
		vim.notify(fname)
		table.insert(bundles, java_test_jar)
	end
end

local config = {
	name = "jdtls",
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
		"-jar",
		vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
		"-data",
		workspace_dir,
	},
	root_dir = vim.fs.root(0, {
		{
			"build.xml", -- Ant
			"pom.xml", -- Maven
			"settings.gradle", -- Gradle
			"settings.gradle.kts", -- Gradle
		},
		{ "gradlew", ".git", "mvnw" },
	}),
	-- single_file_support = true,

	settings = {
		java = {
			signatureHelp = { enabled = true },
			extendedClientCapabilities = extendedClientCapabilities,
			maven = {
				downloadSources = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			format = {
				enabled = false,
			},
		},
	},

	init_options = {
		bundles = bundles,
		-- {
		--
		-- 	vim.fn.glob(
		-- 		home
		-- 			.. "/.local/share/nvim/mason/packages/java-test/extension/server/com.microsoft.java.test.plugin-*.jar"
		-- 	),
		-- },
	},
}

local function setup()
	require("jdtls").start_or_attach(config)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function(args)
		setup()
	end,
})

return {
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		keys = {
			--TODO: add whichkey group for extract
			{
				"<leader>lo",
				"<Cmd>lua require'jdtls'.organize_imports()<CR>",
				mode = "n",
				ft = "java",
				desc = "Organize Imports",
			},
			{
				"<leader>lxv",
				"<Cmd>lua require('jdtls').extract_variable()<CR>",
				mode = "n",
				ft = "java",
				desc = "Extract Variable",
			},
			{
				"<leader>lxv",
				"<Cmd>lua require('jdtls').extract_variable(true)<CR>",
				mode = "v",
				ft = "java",
				desc = "Extract Variable",
			},

			{
				"<leader>lxc",
				"<Cmd>lua require('jdtls').extract_constant()<CR>",
				mode = "n",
				ft = "java",
				desc = "Extract Constant",
			},
			{
				"<leader>lxc",
				"<Cmd>lua require('jdtls').extract_constant(true)<CR>",
				mode = "v",
				ft = "java",
				desc = "Extract Constant",
			},
			{
				"<leader>lxm",
				"<Cmd>lua require('jdtls').extract_method(true)<CR>",
				mode = "v",
				ft = "java",
				desc = "Extract Method",
			},
			{
				"<leader>lt",
				"<Cmd>lua require('jdtls.tests').generate()<CR>",
				mode = "n",
				ft = "java",
				desc = "Generate tests for class",
			},
			{
				"<leader>lgt",
				"<Cmd>lua require('jdtls.tests').goto_subjects()<CR>",
				mode = "n",
				ft = "java",
				desc = "Jump to tests or subjects",
			},
			{
				"<leader>dtc",
				"<Cmd>lua require'jdtls'.test_class()<CR>",
				mode = "n",
				desc = "Test class",
				ft = "java",
			},
			{
				"<leader>dtn",
				"<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
				mode = "n",
				desc = "Test nearest method",
				ft = "java",
			},

			-- " If using nvim-dap
			-- " This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
			-- nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
			-- nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
		},
	},
}
