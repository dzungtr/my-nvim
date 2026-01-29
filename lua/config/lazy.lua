-- Plugin manager bootstrap and configuration
-- lazy.nvim setup with performance optimizations

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if not installed
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Import all plugin specs from lua/plugins/
  spec = {
    { import = "plugins" },
  },

  -- Defaults for plugins
  defaults = {
    lazy = false, -- We explicitly lazy-load where needed
    version = false, -- Don't version match
  },

  -- Disable luarocks (no plugins require it)
  rocks = {
    enabled = false,
  },

  -- Automatically check for updates
  checker = {
    enabled = true,
    notify = false, -- Don't notify on every update check
  },

  -- Detect config changes and reload
  change_detection = {
    enabled = true,
    notify = false,
  },

  -- Performance optimizations
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      -- Disable built-in plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  -- UI settings
  ui = {
    border = "rounded",
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
