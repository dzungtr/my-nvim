-- Treesitter configuration for syntax highlighting
-- Platform engineering language support

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Install parsers for platform engineering languages
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        -- TypeScript/JavaScript/React
        "typescript",
        "tsx",
        "javascript",
        "jsdoc",
        "html",
        "css",
        -- Go
        "go",
        "gomod",
        "gosum",
        "gowork",
        -- Infrastructure
        "yaml",
        "json",
        "jsonc",
        "terraform",
        "hcl",
        -- Other
        "markdown",
        "markdown_inline",
        "bash",
        "dockerfile",
        "toml",
        "gitignore",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitattributes",
      },

      -- Auto install missing parsers
      auto_install = true,

      -- Syntax highlighting
      highlight = {
        enable = true,
        -- Disable for large files (handled by autocmd)
        disable = function(lang, buf)
          if vim.b[buf].large_file then
            return true
          end
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },

      -- Indentation
      indent = {
        enable = true,
        disable = { "python", "yaml" }, -- Better handled by LSP for these
      },

      -- Incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      -- Text objects
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["as"] = "@scope",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    })
  end,
}
