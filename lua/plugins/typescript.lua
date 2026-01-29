-- TypeScript/JavaScript/React LSP configuration
-- Uses typescript-tools.nvim for better performance on large projects

return {
  "pmizio/typescript-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  ft = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  opts = {
    on_attach = function(client, bufnr)
      -- Disable formatting in favor of conform.nvim
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      -- Separate diagnostic server for better performance
      separate_diagnostic_server = true,
      publish_diagnostic_on = "insert_leave",

      -- Code actions
      expose_as_code_action = {
        "fix_all",
        "add_missing_imports",
        "remove_unused",
        "remove_unused_imports",
        "organize_imports",
      },

      -- TypeScript server settings
      tsserver_path = nil,
      tsserver_plugins = {},
      tsserver_max_memory = "auto",
      tsserver_format_options = {},
      tsserver_file_preferences = {
        -- Inlay hints
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,

        -- Completion
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        includeCompletionsWithSnippetText = true,
        includeAutomaticOptionalChainCompletions = true,

        -- Imports
        includePackageJsonAutoImports = "auto",

        -- Other preferences
        quotePreference = "auto",
        importModuleSpecifierPreference = "shortest",
        importModuleSpecifierEnding = "auto",
        allowIncompleteCompletions = true,
        allowRenameOfImportPath = true,
      },
      tsserver_locale = "en",

      -- Completion settings
      complete_function_calls = false,
      include_completions_with_insert_text = true,

      -- Code lens
      code_lens = "off",
      disable_member_code_lens = true,

      -- JSX close tag
      jsx_close_tag = {
        enable = true,
        filetypes = { "javascriptreact", "typescriptreact" },
      },
    },
  },
}
