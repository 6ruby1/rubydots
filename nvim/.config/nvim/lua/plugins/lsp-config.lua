vim.lsp.config("*", {
	root_markers = { ".git" },
})
vim.lsp.enable({
	"lua_ls",
	"clangd",
})

return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = { "mason-org/mason.nvim" },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
					end

					local wk = require("which-key")
					wk.add({
						{ "grn", vim.lsp.buf.rename, desc = "Rename" },
						{ "gra", vim.lsp.buf.code_action, desc = "Goto Code Action", mode = { "n", "x" } },
						{ "grr", require("telescope.builtin").lsp_references, desc = "Goto References" },
						{ "gri", require("telescope.builtin").lsp_implementations, desc = "Goto Implementationtion" },
						{ "grd", require("telescope.builtin").lsp_definitions, desc = "Goto Definition" },
						{ "gO", require("telescope.builtin").lsp_document_symbols, desc = "Open Document Symbols" },
						{
							"gW",
							require("telescope.builtin").lsp_dynamic_workspace_symbols,
							desc = "Open Workspace Symbols",
						},
						{ "grt", require("telescope.builtin").lsp_type_definitions, desc = "Goto Type Definition" },
						-- WARN: This is not Goto Definition, this is Goto Declaration.
						--  For example, in C this would take you to the header.
						{ "grD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
					})

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							---@diagnostic disable-next-line
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>lh", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay Hints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				update_in_insert = true,
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},

				virtual_lines = {
					-- only show diagnostics whose severity is ERROR
					severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
					only_current_line = false,
				},
				-- Show virtual_text for everything except ERROR (WARN/INFO/HINT)
				virtual_text = {
					spacing = 2,
					source = "if_many",
					-- The format function may return nil to suppress virtual_text for that diagnostic.
					format = function(diagnostic)
						-- suppress virtual_text for ERROR-level diagnostics
						if diagnostic.severity == vim.diagnostic.severity.ERROR then
							return nil
						end
						-- otherwise show the message
						return diagnostic.message
					end,
				},
			})

			vim.cmd([[
      highlight link DiagnosticVirtualLinesError DiagnosticVirtualTextError
      highlight link DiagnosticVirtualLinesWarn DiagnosticVirtualTextWarn
      highlight link DiagnosticVirtualLinesInfo DiagnosticVirtualTextInfo
      highlight link DiagnosticVirtualLinesHint DiagnosticVirtualTextHint
      highlight link DiagnosticVirtualLinesOk DiagnosticVirtualTextOk
      ]])

			vim.diagnostic.handlers.loclist = {
				show = function(_, _, _, opts)
					---@diagnostic disable
					-- Generally don't want it to open on every update
					opts.loclist.open = opts.loclist.open or false
					local winid = vim.api.nvim_get_current_win()
					vim.diagnostic.setloclist(opts.loclist)
					vim.api.nvim_set_current_win(winid)
					---@diagnostic enable
				end,
			}

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ts_ls = {},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				-- Language servers
				"basedpyright",
				"bash-language-server",
				"clangd",
				"csharp-language-server",
				"css-lsp",
				"emmet-ls",
				"eslint-lsp",
				-- "gopls",
				"graphql-language-service-cli",
				"html-lsp",
				"hyprls",
				"jdtls", -- NOTE: configured via nvim-jdtls
				"json-lsp",
				-- "kotlin-language-server",
				"lua-language-server",
				"marksman",
				"neocmakelsp",
				-- "sqls",
				-- "tailwindcss-language-server",
				"taplo",
				-- "vtsls",
				"yaml-language-server",

				-- DAP
				"bash-debug-adapter",
				"codelldb",
				"debugpy",
				-- "delve",
				"java-debug-adapter",
				"java-test",
				-- "js-debug-adapter",
				-- "kotlin-debug-adapter",
				-- "netcoredbg",
				-- "cpptools",

				-- Linter
				-- "ktlint",
				"luacheck",
				"shellcheck",
				-- "sqlfluff",
				-- "standardrb",
				"codespell",
				"cpplint",
				"eslint_d",

				-- Formatters
				"black",
				-- "csharpier",
				-- "goimports",
				-- "gomodifytags",
				-- "gotests",
				"isort",
				"prettierd",
				"shfmt",
				"stylua",
				"clang-format",
				"mdformat",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Populated by mason-tool-installer)
				automatic_installation = false,
				automatic_enable = { exclude = { "jdtls", "rust_analyzer" } },
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
