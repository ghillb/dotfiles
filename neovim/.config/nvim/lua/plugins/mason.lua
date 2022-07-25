local packer_opts = {
  "williamboman/mason.nvim",
  disable = vim.env.NVIM_EMBEDDED == "true",
  requires = { "folke/lua-dev.nvim", "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
  config = function()
    local ok, mason = pcall(require, "mason")
    if not ok then
      return
    end

    local config = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }

    mason.setup(config)

    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
      ensure_installed = { "sumneko_lua" },
    })

    -- lsp-config
    local lspconfig = require("lspconfig")
    for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
      local opts = {}
      opts.capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
      -- opts.capabilities.textDocument.completion.completionItem.snippetSupport = true -- not needed?

      if server == "sumneko_lua" then
        opts = require("lua-dev").setup({
          lspconfig = {
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                telemetry = {
                  enable = false,
                },
              },
            },
            on_attach = function(client)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end,
          },
        })
      end

      if server == "ansiblels" then
        opts.filetypes = { "ansible.yaml" }
        opts.settings = {
          ansible = {
            ansible = {
              path = "ansible",
            },
            ansibleLint = {
              enabled = true,
              path = "ansible-lint",
            },
            executionEnvironment = {
              enabled = false,
            },
            python = {
              interpreterPath = "python3",
            },
          },
        }
      end

      if server == "yamlls" then
        opts.filetypes = { "yaml", "yml", "gitlab-ci.yaml", "ansible.yaml", "docker-compose.yaml", "kubernetes.yaml" }
        opts.settings = {
          yaml = {
            schemas = {
              ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/*gitlab[-]ci*.yml",
              ["https://raw.githubusercontent.com/docker/cli/master/cli/compose/schema/data/config_schema_v3.9.json"] = "/*docker[-]compose*.yml",
              ["kubernetes"] = { "/k8s/*.yml", "/k8s/*.yaml" },
            },
            validate = true,
            hover = true,
            completion = true,
            format = {
              enable = true,
            },
          },
        }
      end

      if server == "terraformls" then
        opts.filetypes = { "tf", "hcl", "terraform" }
        opts.settings = {}
      end

      lspconfig[server].setup({
        settings = opts.settings,
        filetypes = opts.filetypes,
        on_attach = opts.on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        capabilities = opts.capabilities,
      })
    end
  end,
}
return packer_opts
