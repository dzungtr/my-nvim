-- Colorscheme configuration
-- Catppuccin theme with extensive plugin integrations

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Load before other plugins
  lazy = false, -- Load immediately
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = {},
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = false,
        neotree = true,
        treesitter = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        dap = true,
        dap_ui = true,
        telescope = {
          enabled = true,
        },
        which_key = true,
        mason = true,
        noice = true,
      },
    })

    -- Set colorscheme
    vim.cmd.colorscheme("catppuccin")
  end,
}
