-- Treesitter configuration for syntax highlighting
-- Platform engineering language support

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
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
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      -- Prevent built-in ftplugin mapping conflicts
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
        swap = {},
      })

      -- Select text objects
      vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end, { desc = "Select outer function" })
      vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end, { desc = "Select inner function" })
      vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
      end, { desc = "Select outer class" })
      vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
      end, { desc = "Select inner class" })
      vim.keymap.set({ "x", "o" }, "as", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
      end, { desc = "Select scope" })
      vim.keymap.set({ "x", "o" }, "al", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@loop.outer", "textobjects")
      end, { desc = "Select outer loop" })
      vim.keymap.set({ "x", "o" }, "il", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@loop.inner", "textobjects")
      end, { desc = "Select inner loop" })
      vim.keymap.set({ "x", "o" }, "ab", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects")
      end, { desc = "Select outer block" })
      vim.keymap.set({ "x", "o" }, "ib", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects")
      end, { desc = "Select inner block" })
      vim.keymap.set({ "x", "o" }, "aa", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
      end, { desc = "Select outer parameter" })
      vim.keymap.set({ "x", "o" }, "ia", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
      end, { desc = "Select inner parameter" })

      -- Move to next/previous text objects
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "]F", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
      end, { desc = "Next function end" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Previous function start" })
      vim.keymap.set({ "n", "x", "o" }, "[F", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
      end, { desc = "Previous function end" })
      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
      end, { desc = "Next class start" })
      vim.keymap.set({ "n", "x", "o" }, "]C", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
      end, { desc = "Next class end" })
      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
      end, { desc = "Previous class start" })
      vim.keymap.set({ "n", "x", "o" }, "[C", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
      end, { desc = "Previous class end" })

      -- Swap parameters
      vim.keymap.set("n", "<leader>a", function()
        require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
      end, { desc = "Swap with next parameter" })
      vim.keymap.set("n", "<leader>A", function()
        require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
      end, { desc = "Swap with previous parameter" })
    end,
  },
}
