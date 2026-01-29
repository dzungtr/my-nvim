-- Kubernetes YAML support with schema validation
-- yaml-companion for automatic schema detection

return {
  "someone-stole-my-name/yaml-companion.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  ft = { "yaml", "yaml.docker-compose" },
  config = function()
    local cfg = require("yaml-companion").setup({
      -- Built-in matchers
      builtin_matchers = {
        kubernetes = { enabled = true },
        cloud_init = { enabled = false },
      },

      -- Schemas from SchemaStore and custom sources
      schemas = {
        {
          name = "Kubernetes 1.28",
          uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.28.0-standalone-strict/all.json",
        },
        {
          name = "Kubernetes 1.29",
          uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/all.json",
        },
        {
          name = "Argo CD Application",
          uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
        },
        {
          name = "Argo Workflows",
          uri = "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json",
        },
        {
          name = "GitHub Workflow",
          uri = "https://json.schemastore.org/github-workflow.json",
        },
        {
          name = "GitHub Action",
          uri = "https://json.schemastore.org/github-action.json",
        },
        {
          name = "Docker Compose",
          uri = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
        },
        {
          name = "Kustomization",
          uri = "https://json.schemastore.org/kustomization.json",
        },
        {
          name = "Helm Chart",
          uri = "https://json.schemastore.org/chart.json",
        },
      },

      -- LSP config for yamlls
      lspconfig = {
        flags = {
          debounce_text_changes = 150,
        },
        settings = {
          redhat = {
            telemetry = {
              enabled = false,
            },
          },
          yaml = {
            validate = true,
            format = {
              enable = true,
              singleQuote = false,
              bracketSpacing = true,
            },
            hover = true,
            completion = true,
            schemaStore = {
              enable = true,
              url = "https://www.schemastore.org/api/json/catalog.json",
            },
            schemas = {
              kubernetes = "*.yaml",
              ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
              ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
              ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
              ["https://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
            },
            customTags = {
              "!fn",
              "!And",
              "!If",
              "!Not",
              "!Equals",
              "!Or",
              "!FindInMap sequence",
              "!Base64",
              "!Cidr",
              "!Ref",
              "!Sub",
              "!GetAtt",
              "!GetAZs",
              "!ImportValue",
              "!Select",
              "!Split",
              "!Join sequence",
            },
          },
        },
      },
    })

    -- Setup yamlls with yaml-companion config
    require("lspconfig")["yamlls"].setup(cfg)

    -- Load telescope extension
    require("telescope").load_extension("yaml_schema")
  end,
  keys = {
    { "<leader>ys", "<cmd>Telescope yaml_schema<cr>", desc = "YAML Schema", ft = "yaml" },
  },
}
