-- Telescope fuzzy finder with fzf-native extension
-- File finding, live grep, LSP integration

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  keys = {
    -- File finding
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep Word" },

    -- LSP
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },

    -- Git
    { "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
    { "<leader>fC", "<cmd>Telescope git_bcommits<cr>", desc = "Buffer Commits" },
    { "<leader>fB", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
    { "<leader>ft", "<cmd>Telescope git_status<cr>", desc = "Git Status" },

    -- Other
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { "<leader>fp", "<cmd>Telescope resume<cr>", desc = "Resume Picker" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix = "  ",
        selection_caret = " ",
        path_display = { "smart" },
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
          "target/",
          "vendor/",
          "%.lock",
          "__pycache__",
          "%.o",
          "%.a",
          "%.out",
          "%.class",
          "%.pdf",
          "%.mkv",
          "%.mp4",
          "%.zip",
        },
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key, -- <C-/>
          },
          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["?"] = actions.which_key,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
        buffers = {
          sort_mru = true,
          sort_lastused = true,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    -- Load fzf extension
    pcall(telescope.load_extension, "fzf")
  end,
}
