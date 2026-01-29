-- NvChad-style keymappings
-- Leader key is set in init.lua before this loads

local map = vim.keymap.set

-- General
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "General Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "General Copy whole file" })

map("n", "<leader>ln", "<cmd>set nu!<CR>", { desc = "Toggle line number" })
map("n", "<leader>lr", "<cmd>set rnu!<CR>", { desc = "Toggle relative number" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Resize window up" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Resize window down" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize window left" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize window right" })

-- Window splits
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontal" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Split close" })

-- Buffers (navigation handled by bufferline.nvim)
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Buffer delete" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Buffer close" })

-- File operations
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all" })

-- Visual mode indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Better paste
map("v", "p", '"_dP', { desc = "Paste without yank" })

-- Terminal navigation
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Terminal window left" })
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Terminal window down" })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Terminal window up" })
map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Terminal window right" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal escape" })

-- Scrolling (keep cursor centered)
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
map("n", "n", "nzzzv", { desc = "Search next" })
map("n", "N", "Nzzzv", { desc = "Search prev" })
