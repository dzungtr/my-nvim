-- Entry point for Neovim configuration
-- Sets leader keys before lazy.nvim loads (CRITICAL)

-- Set leader keys first
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load core configuration
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
