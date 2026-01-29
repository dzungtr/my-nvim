-- Go development configuration
-- Integrated gopls, test runners, debugger support

return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("go").setup({
      -- Disable LSP config as we handle it in lsp.lua
      lsp_cfg = false,
      lsp_gofumpt = true,
      lsp_on_attach = nil,
      lsp_keymaps = false,
      lsp_codelens = true,

      -- Inlay hints
      lsp_inlay_hints = {
        enable = true,
        only_current_line = false,
        only_current_line_autocmd = "CursorHold",
        show_variable_name = true,
        parameter_hints_prefix = " ",
        show_parameter_hints = true,
        other_hints_prefix = " ",
      },

      -- Formatting
      goimports = "gopls",
      gofmt = "gopls",
      max_line_len = 120,
      tag_transform = false,
      tag_options = "json=omitempty",

      -- Testing
      run_in_floaterm = true,
      test_runner = "go",
      verbose_tests = true,

      -- Debugging
      dap_debug = true,
      dap_debug_keymap = true,
      dap_debug_gui = true,
      dap_debug_vt = true,

      -- Build tags
      build_tags = "",
      textobjects = true,

      -- Linter
      linter = "golangci-lint",
      lint_prompt_style = "vt",

      -- Icons
      icons = {
        breakpoint = "🔴",
        currentpos = "🔶",
      },

      -- Trouble integration
      trouble = false,

      -- Luasnip integration
      luasnip = true,
    })

    -- Auto-format on save for Go files
    local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        require("go.format").goimports()
      end,
      group = format_sync_grp,
    })

    -- Go-specific keymaps
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function()
        local opts = { buffer = true }
        vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<cr>", vim.tbl_extend("force", opts, { desc = "Run tests" }))
        vim.keymap.set("n", "<leader>gT", "<cmd>GoTestFunc<cr>", vim.tbl_extend("force", opts, { desc = "Test function" }))
        vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<cr>", vim.tbl_extend("force", opts, { desc = "Coverage" }))
        vim.keymap.set("n", "<leader>gC", "<cmd>GoCoverageClear<cr>", vim.tbl_extend("force", opts, { desc = "Clear coverage" }))
        vim.keymap.set("n", "<leader>gd", "<cmd>GoDoc<cr>", vim.tbl_extend("force", opts, { desc = "Documentation" }))
        vim.keymap.set("n", "<leader>gi", "<cmd>GoImpl<cr>", vim.tbl_extend("force", opts, { desc = "Implement interface" }))
        vim.keymap.set("n", "<leader>gf", "<cmd>GoFillStruct<cr>", vim.tbl_extend("force", opts, { desc = "Fill struct" }))
        vim.keymap.set("n", "<leader>ga", "<cmd>GoAddTag<cr>", vim.tbl_extend("force", opts, { desc = "Add tags" }))
        vim.keymap.set("n", "<leader>gr", "<cmd>GoRmTag<cr>", vim.tbl_extend("force", opts, { desc = "Remove tags" }))
        vim.keymap.set("n", "<leader>ge", "<cmd>GoIfErr<cr>", vim.tbl_extend("force", opts, { desc = "Add if err" }))
        vim.keymap.set("n", "<leader>gm", "<cmd>GoMod tidy<cr>", vim.tbl_extend("force", opts, { desc = "Go mod tidy" }))
      end,
    })
  end,
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()',
}
