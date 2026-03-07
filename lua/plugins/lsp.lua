-- LSP configuration with Mason for automatic server management
-- Base LSP setup for all language servers

return {
  -- Mason: LSP server installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      max_concurrent_installers = 10,
    },
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local lspconfig = require("lspconfig")

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          focusable = false,
        },
      })

      -- Custom diagnostic signs
      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- LSP handlers with borders
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- LspAttach autocommand for keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Disable inlay hints
          vim.lsp.inlay_hint.enable(false)

          local map = vim.keymap.set
          local function opts(desc)
            return { buffer = ev.buf, desc = "LSP " .. desc }
          end

          -- LSP keymaps (NvChad style)
          map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
          map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
          map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
          map("n", "gr", vim.lsp.buf.references, opts("References"))
          map("n", "K", vim.lsp.buf.hover, opts("Hover"))
          map("n", "<leader>ls", vim.lsp.buf.signature_help, opts("Signature help"))
          map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Type definition"))
          map("n", "<leader>ra", vim.lsp.buf.rename, opts("Rename"))
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
          map("n", "<leader>fm", function()
            vim.lsp.buf.format({ async = true })
          end, opts("Format"))

          -- Workspace
          map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
          map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
          map("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts("List workspace folders"))

          -- Diagnostics
          map("n", "[d", vim.diagnostic.goto_prev, opts("Prev diagnostic"))
          map("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))
          map("n", "<leader>lf", vim.diagnostic.open_float, opts("Floating diagnostic"))
          map("n", "<leader>ql", vim.diagnostic.setloclist, opts("Diagnostic loclist"))
        end,
      })

      -- Server-specific configurations
      local server_configs = {
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  "${3rd}/luv/library",
                },
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
              telemetry = {
                enable = false,
              },
              hint = {
                enable = true,
              },
            },
          },
        },

        -- Go
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = {
                "-.git",
                "-.vscode",
                "-.idea",
                "-.vscode-test",
                "-node_modules",
              },
              semanticTokens = true,
            },
          },
        },

        -- YAML (basic config, extended in kubernetes.lua)
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },

        -- JSON
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
      }

      -- Setup mason-lspconfig with handlers
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "gopls",
          "terraformls",
          "tflint",
          "yamlls",
          "helm_ls",
          "dockerls",
          "bashls",
          "marksman",
          "jsonls",
        },
        automatic_installation = true,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            local config = server_configs[server_name] or {}
            -- Add blink.cmp capabilities for completion support
            config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
            lspconfig[server_name].setup(config)
          end,
        },
      })
    end,
  },
}
