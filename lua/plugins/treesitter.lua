return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").install({
        "lua",
        "vim",
        "vimdoc",
        "query",
        "typescript",
        "tsx",
        "javascript",
        "jsdoc",
        "html",
        "css",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "yaml",
        "json",
        "jsonc",
        "terraform",
        "hcl",
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
      })

      local function is_large_file(buf)
        if vim.b[buf].large_file then
          return true
        end
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        return ok and stats and stats.size > 100 * 1024
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if not is_large_file(ev.buf) then
            pcall(vim.treesitter.start)
          end
        end,
      })

      -- incremental_selection is not provided by nvim-treesitter on main
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local ft = vim.bo[ev.buf].filetype
          if ft ~= "python" and ft ~= "yaml" and not is_large_file(ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
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
