-- Formatting with conform.nvim (null-ls successor)
-- Language-specific formatters for platform engineering

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    -- Formatters by filetype
    formatters_by_ft = {
      -- JavaScript/TypeScript/React
      javascript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },

      -- Go
      go = { "gofumpt", "goimports" },

      -- Infrastructure as Code
      terraform = { "terraform_fmt" },
      tf = { "terraform_fmt" },
      hcl = { "terraform_fmt" },

      -- YAML
      yaml = { "prettier" },

      -- Configuration files
      json = { "prettier" },
      jsonc = { "prettier" },
      toml = { "taplo" },

      -- Lua
      lua = { "stylua" },

      -- Python
      python = { "isort", "black" },

      -- Shell scripts
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },

      -- Markdown
      markdown = { "prettier" },

      -- HTML/CSS
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },

      -- Docker
      dockerfile = { "dprint" },
    },

    -- Format on save
    format_on_save = function(bufnr)
      -- Disable for large files
      if vim.b[bufnr].large_file then
        return
      end

      return {
        timeout_ms = 500,
        lsp_fallback = true,
      }
    end,

    -- Formatter-specific settings
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2", "-ci" },
      },
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
    },

    -- Notify on format errors
    notify_on_error = true,
  },
  init = function()
    -- Use conform for gq formatting
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
