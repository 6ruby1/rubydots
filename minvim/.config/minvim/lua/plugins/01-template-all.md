---@type LazySpec
return {
  -- INFO: install plugin and run require('plugin').setup()
  { "user/repo", opts = {} },

  -- INFO: install plugin and run require('plugin').setup(opts)
  {
    "user/repo",
    opts = {
      settingBool = true,
      settingString = "",
      settingTbl = {
        settingTblItem = "",
      },
    },
  },

  -- INFO: install plugin with dependencies
  -- NOTE: dependencies will only load when plugin loads
  -- NOTE: dependencies are always lazy-loaded unless specified otherwise
  {
    "user/repo",
    dependencies = {
      "user2/dependency1",
      "user3/dependency2",
    },
    opts = {},
  },

  -- INFO: config can run a lua function
  -- WARN: use config INSTEAD OF opts
  {
    "user/repo",
    config = function()
      -- some lua here
      require("user/repo").setup()
      vim.cmd([[someCommand arg]])
    end,
  },

  -- INFO: configuration for plugin is located elsewhere, it loads when config does
  { "user/repo", lazy = true },

  -- INFO: `lazy = false` will force the plugin to load on startup
  {
    "user/repo",
    lazy = false,
    config = function()
      vim.cmd([[someCommand arg]])
    end,
  },

  -- INFO: using `lazy = false` and `priority = 1000` will force the
  -- plugin to load before all others
  -- INFO: Useful for loading a colorscheme
  {
    "user/repo",
    lazy = false,
    priority = 1000,
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme example]])
    end,
  },

  -- INFO: you can use the VeryLazy event for things that can
  -- load later and are not important for the initial UI
  { "user/repo",                                event = "VeryLazy" },

  -- INFO: `event = "someEvent"` will only load the plugin when it occurs
  {
    "user/repo",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    config = function()
      -- ...
    end,
  },

  -- INFO: `ft = "someFileType"` will only load the plugin for that type
  {
    "user/repo",
    -- lazy-load on filetype
    ft = "lua",
    opts = {},
  },

  -- INFO: `cmd = "command"` loads a plugin when a command occurs
  {
    "user/repo",
    -- lazy-load on a command
    cmd = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- INFO: load a plugin when a keybind is used
  {
    "user/repo",
    keys = {
      { "J", "<cmd>SomeCommand<cr>", desc = "Command desc" },
    },
  },

  -- INFO: load a plugin when a keybind is used, advanced
  {
    "user/repo",
    keys = { "<C-a>", { "<C-x>", mode = "n" } },
  },

  -- INFO: load a local plugin
  -- WARN: local plugins need to be explicitly configured with dir
  { dir = "~/projects/secret.nvim" },

  -- INFO: load a plugin with a custom url
  { url = "git@github.com:folke/noice.nvim.git" },

  -- INFO: local plugins can also be configured with the dev option.
  -- This will use {config.dev.path}/noice.nvim/ instead of fetching it from GitHub
  -- With the dev option, you can easily switch between the local and installed version of a plugin
  { "user/repo",                                dev = true },
}
