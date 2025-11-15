vim.lsp.config("*", {
  root_markers = { ".git" },
})
vim.lsp.enable({
  "lua_ls",
})

---@type LazySpec
return {
  { "https://github.com/neovim/nvim-lspconfig" },
  { "mason-org/mason.nvim" },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- WARN: Modify configs in the lsp directory
      ensure_installed = { "lua_ls" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
