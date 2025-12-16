---@type LazySpec
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},

	config = function()
		---@module "conform"
		---@type conform.setupOpts
		require("conform").setup({
			notify_on_error = true,
			notify_no_formatters = true,

			formatters_by_ft = {
				-- Lang
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				cpp = { "clang-format" },
				rust = { "rustfmt" },
				markdown = { "mdformat", "injected" },

				-- Data
				json = { "prettierd" },
				css = { "prettierd" },
				yaml = { "prettierd" },
				toml = { "taplo" },

				-- ["*"] to run on all filetypes
				["*"] = { "trim_whitespace" },

				-- ["_"] to run on filetypes without formatters
			},

			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},

			-- Customize formatters
			formatters = {
				shfmt = {
					append_args = { "-i", "2" },
				},
				["clang-format"] = {
					prepend_args = {
						"-style={ \
				            IndentWidth: 2, \
				            TabWidth: 2, \
				            UseTab: Never, \
				            AccessModifierOffset: 0, \
				            IndentAccessModifiers: true, \
				            PackConstructorInitializers: Never}",
					},
				},
				injected = {
					options = {
						-- Set to true to ignore errors
						ignore_errors = false,
						-- Map of treesitter language to filetype
						lang_to_ft = {
							bash = "sh",
						},
						-- Map of treesitter language to file extension
						-- A temporary file name with this extension will be generated during formatting
						-- because some formatters care about the filename.
						lang_to_ext = {
							bash = "sh",
							c_sharp = "cs",
							elixir = "exs",
							javascript = "js",
							julia = "jl",
							latex = "tex",
							markdown = "md",
							python = "py",
							ruby = "rb",
							rust = "rs",
							teal = "tl",
							typescript = "ts",
						},
						-- Map of treesitter language to formatters to use
						-- (defaults to the value from formatters_by_ft)
						lang_to_formatters = {},
					},
				},
			},

			-- Set up format-on-save
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
		})

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
